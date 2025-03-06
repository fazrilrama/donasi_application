const connect = require('../../../config/connection');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

module.exports = {
    login: async (req, res) => {
        let connection;

        try {
            connection = await connect.getConnection();

            const { email, password } = req.body;

            const [user] = await connection.query(
                'SELECT * FROM users WHERE email = ?',
                [email]
            );

            if(user.length === 0) {
                return res.status(400).json({
                    status: false,
                    message: 'Email not found'
                });
            }

            const userPassword = user[0].password;
            const adjustedHash = userPassword.replace('$2y$', '$2b$');
            const isPasswordValid = await bcrypt.compare(password, adjustedHash);

            if(!isPasswordValid) {
                return res.status(400).json({
                    status: false,
                    message: 'Invalid password'
                });
            }

            const token = jwt.sign({ ...user[0] }, process.env.SECRET_KEY);

            return res.status(200).json({
                status: true,
                message: 'Login successful',
                token: token,
                user: user[0]
            });

        } catch(err) {
            return res.status(500).json({
                status: false,
                message: 'Internal Server Error',
                error: err.message
            });
        } finally {
            if(connection) {
                connection.release();
            }
        }
    },

    register: async (req, res) => {
        let connection;
        try {
            connection = await connect.getConnection();
            await connection.beginTransaction();

            const { name, email, phone, password, role, latitude, longitude } = req.body;

            const [checkEmail] = await connection.query(
                'SELECT * FROM users WHERE email = ?'
            , [email]);

            if(checkEmail.length > 0) {
                return res.status(400).json({
                    status: false,
                    message: 'Email already exists'
                });
            }

            const hashedPassword = await bcrypt.hash(password, 10);

            await connection.query(
                'INSERT INTO users (name, email, phone, password, role, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?)',
                [name, email, phone, hashedPassword, role, latitude, longitude]
            );

            await connection.commit();
            return res.status(200).json({ 
                status: true,
                message: 'Registration successful',
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
}