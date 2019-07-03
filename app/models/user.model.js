/*jshint esversion: 6 */

const mongoose = require("mongoose");
const user_location_data = require("./location.model");
const Schema = mongoose.Schema;

// Create Schema
const UserSchema = new Schema({
    name: {
        type: [String],
        required: true
    },
    email: {
        type: [String],
        required: true
    },
    password: {
        type: String,
        required: true
    },
    date: {
        type: Date,
        default: Date.now
    }
});

module.exports = User = mongoose.model("users", UserSchema);