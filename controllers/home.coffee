express = require "express"
User = require "../models/User"

module.exports = app = express()

app.get "/", (req, res, next) ->
   User.findOne primary: true, (error, user) ->
      return next error if error
      res.render "home",
         lat: user.lat
         lng: user.lng
         active: user.active