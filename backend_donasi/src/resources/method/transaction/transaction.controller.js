const connect = require('../../../config/connection');

module.exports = {
    create: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            await connection.beginTransaction();

            const user = req.user;
            const { id } = req.params;
            const { amount, payment_method, payment_proof } = req.body;
            const user_id = user.id;

            await connection.query(
                'INSERT INTO transactions (user_id, campaign_id, amount, payment_method, payment_proof) VALUES (?,?,?,?,?)'
            , [user_id, id, amount, payment_method, payment_proof]);

            await connection.commit();
            return res.status(200).json({
                status: true,
                message: 'Transaction Success'
            });

        } catch(error) {
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

    listByCampaign: async(req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            const { id } = req.params;

            const [transactions] = await connection.query(
                'SELECT * FROM transactions WHERE campaign_id = ?'
            , [id]);

            return res.status(200).json({
                status: true,
                message: 'List Transaction Success',
                body: transactions
            });

        } catch(error) {
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