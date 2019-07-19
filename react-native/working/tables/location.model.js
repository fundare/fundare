/*jshint esversion: 6 */

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const location_data = new Schema({
    lat: mongoose.Decimal128,
    long: mongoose.Decimal128,
    elev: mongoose.Decimal128,
    datetime: String
});

const user_location_data = new Schema({
    uuid: {
        type: Number
    },
    username: {
        type: [String]
    },
    account_type: {
        type: String
    },
    locations: [{ location_data }],
    last_location: { location_data }
});

module.exports = mongoose.model('user_location_data', user_location_data);