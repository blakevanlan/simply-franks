express = require "express"
rest = require "request"
config = require "../config/app"
User = require "../models/User"

module.exports = (io) ->

   app = express()

   app.get "/", (req, res, next) ->
      User.findOne primary: true, (error, user) ->
         return next error if error
         res.render "home",
            lat: user.lat
            lng: user.lng
            active: user.active

   return app
