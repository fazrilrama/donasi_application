require("dotenv").config();
const mysql = require('mysql2/promise');


const connect = mysql.createPool({
    queueLimit: 0,
    enableKeepAlive: true,
    multipleStatements: true,
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    dateStrings: 'date'
});

module.exports = connect;