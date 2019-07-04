#!/usr/bin/env nodejs

/*jshint esversion: 6 */
const app = require('./app.js');

const bodyParser = require('body-parser');
const passport = require("passport");
const users = require("./routes/api/users");
const cors = require('cors');
const mongoose = require('mongoose');

app.use(cors());
app.use(bodyParser.json());
app.use(
    bodyParser.urlencoded({
        extended: false
    })
);
// DB Config
const db = require("./config/keys").mongoURI;

// Connect to MongoDB
mongoose
    .connect(
        db, { useNewUrlParser: true }
    )
    .then(() => console.log("MongoDB successfully connected"))
    .catch(err => console.log(err));

// Passport middleware
app.use(passport.initialize());

// Passport config
require("./config/passport")(passport);

// Routes
app.use("/api/users", users);

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`Server up and running on port ${port}!`));