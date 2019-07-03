#!/usr/bin/env nodejs

/*jshint esversion: 6 */
const app = require('./app.js');

const bodyParser = require('body-parser');
const cors = require('cors');
const mongoose = require('mongoose');
// const fundareRoutes = express.Router();
const port = process.env.PORT || 3000;

// let user_schema = require('./models/user.model');

app.use(cors());
app.use(bodyParser.json());

mongoose.connect('mongodb://127.0.0.1:27017/fundare', { useNewUrlParser: true });
const connection = mongoose.connection;

connection.once('open', () => {
    console.log("MongoDB database connection established successfully.");
});


app.listen(port, () => {
    console.log("Server is running on Port " + port + ".");
});