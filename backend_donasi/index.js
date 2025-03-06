const express = require('express');
const app = express();
const dotenv = require('dotenv');
const morgan = require('morgan');
const bodyParser = require('body-parser');
const fileUpload = require('express-fileupload');
const path = require('path');
const cors = require('cors');
const { createServer } = require('http');
const router = require('./src/resources/environtment/router_list');
require('dotenv').config();

dotenv.config({
    path: './.env'
});

const port = process.env.PORT ?? 8003;


app.use(cors({ origin: true }));
app.use(express.json());
app.use(morgan('tiny'));
app.use(bodyParser.json({ limit: '200mb', extended: true }));
app.use(fileUpload());
app.use('/ns', express.static(path.join(__dirname, 'public')));

app.use(`${process.env.BASE_API_URL}`, router);

app.use((req, res) => {
    res.status(404).json({
        message: '404_NOT_FOUND'
    });
});

app.listen(port, () => {
    console.log("Server Listening on PORT:", port);
});