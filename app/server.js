#!/usr/bin/env nodejs

/*jshint esversion: 6 */
const express = require("express");
// const mongoose = require("mongoose");
const bodyParser = require("body-parser");
const passport = require("passport");

const users = require("./routes/api/users");

const app = express();

// Bodyparser middleware
app.use(
    bodyParser.urlencoded({
        extended: false
    })
);
app.use(bodyParser.json());

// DB Config
// Connect to MongoDB
const MongoClient = require("mongodb").MongoClient;
const uri = require("./config/keys").mongoURI;
const mongo = new MongoClient(uri, { useNewUrlParser: true });


mongo.connect(err => {
    const db_collection = mongo.db("fundare").collection("user_credentials");
    client.close();
});

// Passport middleware
app.use(passport.initialize());

// Passport config
require("./config/passport")(passport);

// Routes
app.use("/api/users", users);

db.collection("user_credentials").insertOne(users, (err, result) => {
    if (err) return console.log(err);
    console.log("User registered!");
    console.log(results);
});

const port = process.env.PORT || 5000;

app.listen(port, () => console.log(`Server up and running on port ${port} !`));