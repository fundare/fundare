/*jshint esversion: 6 */

var mongo_password = process.env.mongo_password;

module.exports = {
    mongoURI: "mongodb+srv://bryan:" + mongo_password + "@cluster0-ockae.gcp.mongodb.net/test?retryWrites=true&w=majority"
};