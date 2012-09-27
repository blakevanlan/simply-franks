mongoose = require "mongoose"

userSchema = new mongoose.Schema
   username: String
   password: String
   lat: Number
   lng: Number
   active: Boolean
   primary: Boolean

module.exports = mongoose.model "User", userSchema

# user = new User
#    username: "admin"
#    password: "testing"
#    lat: 0
#    lng: 0
#    active: true