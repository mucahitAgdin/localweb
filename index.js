const express = require('express');
const app = express();
const https = require('https');
require('dotenv').config()
const fs = require('fs');
const port = process.env.PORT;

app.get('/', (req, res) => {
    res.send("IT'S WORKING!");
});

const httpsOptions = {
    key: fs.readFileSync(process.env.CERT_KEY),
    cert: fs.readFileSync(process.env.CERT_PEM)
};

const server = https.createServer(httpsOptions, app)
    .listen(port, () => {
        console.log('Server running at port ' + port);
    });