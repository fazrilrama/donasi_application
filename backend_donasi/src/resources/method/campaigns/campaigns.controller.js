const connect = require('../../../config/connection');
const { generateString } = require('../../../helpers/rengine_helper');
const path = require('path');

module.exports = {
    create: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            await connection.beginTransaction();

            const { title, description, target_amount, collected_amount, deadline, status } = req.body;
            const user = req.user;
            
            const [checkCampaign] = await connection.query(
                'SELECT * FROM campaigns WHERE title = ? AND status = ?',
                [title, 'open']
            );

            if(checkCampaign.length > 0) {
                return res.status(400).json({
                    status: false,
                    message: 'Campaign already exists'
                });
            }

            await connection.query(
                'INSERT INTO campaigns (title, description, target_amount, collected_amount, deadline, status, user_id) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [title, description, target_amount, collected_amount, deadline, status, user.id]
            );

            await connection.commit();
            return res.status(200).json({ 
                status: true,
                message: 'Create Campaign Success',
                body: req.body
            });
            
        } catch (error) {
            await connection.rollback();
            return res.status(500).json({
                status: false,
                message: 'Internal Server Error',
                error: error.message
            });
        } finally {
            if(connection) {
                connection.release();
            }
        }
    },

    detail: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            const { id } = req.params;
    
            // First check if campaign exists
            const [campaignResult] = await connection.query(
                'SELECT * FROM campaigns WHERE id = ?',
                [id]
            );
            
            if(campaignResult.length === 0) {
                return res.status(404).json({
                    status: false,
                    message: 'Campaign not found'
                });
            }
    
            // Get all data in parallel for better performance
            const [transactionsResult, imagesResult] = await Promise.all([
                connection.query(
                    'SELECT id, amount, created_at, status, user_id, campaign_id FROM transactions WHERE campaign_id = ?',
                    [id]
                ),
                connection.query(
                    'SELECT id, name, campaign_id FROM campaign_images WHERE campaign_id = ?',
                    [id]
                )
            ]);
    
            // Build the response object
            const campaign = {
                ...campaignResult[0],
                length_transaction: transactionsResult[0].length || 0,
                percentage: (campaignResult[0].collected_amount / campaignResult[0].target_amount) * 100,
                transactions: transactionsResult[0] || [],
                images: imagesResult[0] || []
            };
    
            return res.status(200).json({
                status: true,
                message: 'Detail Campaign Success',
                data: campaign
            });
    
        } catch (error) {
            console.error('Error fetching campaign detail:', error);
            return res.status(500).json({
                status: false,
                message: 'Internal Server Error',
                error: error.message
            });
        } finally {
            if(connection) {
                connection.release();
            }
        }
    },

    /**
     * Creates campaign images, handling both single and multiple file uploads
     */
    createImage: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            await connection.beginTransaction();

            const { id } = req.params;
            
            // Check if campaign exists
            const [checkCampaign] = await connection.query(
                'SELECT id FROM campaigns WHERE id = ?',
                [id]
            );

            if(checkCampaign.length === 0) {
                return res.status(404).json({
                    status: false,
                    message: 'Campaign not found'
                });
            }

            // Handle file uploads if files exist
            if(req.files) {
                const photos = req.files.photo;
                
                // Convert single file to array format for consistent handling
                const photoArray = Array.isArray(photos) ? photos : [photos];
                
                // Prepare batch insert values
                const insertValues = [];
                const uploadPromises = [];
                
                for(const photo of photoArray) {
                    const random = generateString(10);
                    const fileName = `${random}${path.parse(photo.name).ext}`;
                    
                    // Add to values array for batch insert
                    insertValues.push([id, fileName]);
                    
                    // Queue file move operations
                    uploadPromises.push(
                        photo.mv(`${process.env.PHOTO_UPLOAD}/${fileName}`)
                    );
                }
                
                // Execute all file moves in parallel
                await Promise.all(uploadPromises);
                
                // Batch insert all image records if we have any
                if(insertValues.length > 0) {
                    await connection.query(
                        'INSERT INTO campaign_images (campaign_id, name) VALUES ?',
                        [insertValues]
                    );
                }
            }

            await connection.commit();
            return res.status(200).json({
                status: true,
                message: 'Campaign Images Uploaded Successfully'
            });

        } catch (error) {
            if(connection) {
                await connection.rollback();
            }
            
            console.error('Error uploading campaign images:', error);
            return res.status(500).json({
                status: false,
                message: 'Internal Server Error',
                error: error.message
            });
        } finally {
            if(connection) {
                connection.release();
            }
        }
    },

    list: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            const user = req.user;
            
            const query = user.role === 'donatur' 
                ? 'SELECT * FROM campaigns WHERE status = ?' 
                : (user.role === 'admin' 
                    ? 'SELECT * FROM campaigns' 
                    : 'SELECT * FROM campaigns WHERE user_id = ?');

            const queryParams = user.role === 'donatur' 
                ? ['open'] 
                : (user.role === 'admin' 
                    ? [] 
                    : [user.id]);

            const [campaigns] = await connection.query(query, queryParams);

            // Jika tidak ada campaign, langsung kembalikan respon
            if (campaigns.length === 0) {
                return res.status(200).json({
                    status: true,
                    message: 'List Campaign Success',
                    data: []
                });
            }

            const campaignIds = campaigns.map(campaign => campaign.id);

            const [transactions] = await connection.query(
                'SELECT * FROM transactions WHERE campaign_id IN (?)', 
                [campaignIds]
            );

            const transactionMap = transactions.reduce((acc, transaction) => {
                if (!acc[transaction.campaign_id]) {
                    acc[transaction.campaign_id] = [];
                }
                acc[transaction.campaign_id].push(transaction);
                return acc;
            }, {});

            const campaignsWithTransactions = campaigns.map(campaign => {
                // Hitung persentase dari target dan collected amount
                const percentage = campaign.target_amount > 0 
                    ? (campaign.collected_amount / campaign.target_amount) * 100 
                    : 0;
                    
                return {
                    ...campaign,
                    percentage: parseInt(percentage),
                    length_transaction: transactionMap[campaign.id]?.length || 0,
                    transactions: transactionMap[campaign.id] || []
                };
            });

            return res.status(200).json({
                status: true,
                message: 'List Campaign Success',
                data: campaignsWithTransactions
            });

        } catch (error) {
            return res.status(500).json({
                status: false,
                message: 'Internal Server Error',
                error: error.message
            });
        } finally {
            if(connection) {
                connection.release();
            }
        }
    }
}
