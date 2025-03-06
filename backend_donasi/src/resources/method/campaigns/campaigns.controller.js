const connect = require('../../../config/connection');

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
