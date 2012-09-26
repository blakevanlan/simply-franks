express = require "express"
rest = require "request"
config = require "../config/app"

app = module.exports = express()

app.get "/", (req, res, next) ->
   res.render "home", 
      lat: 39.1897705
      lng: -96.57086679999999
