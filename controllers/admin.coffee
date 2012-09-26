express = require "express"
rest = require "request"
config = require "../config/app"

module.exports = (io) ->
   app = express()

   io.sockets.on "connection", (socket) ->
      socket.on "tracking_switch", (data) ->
         console.log "TRACKING: ", data
      
      socket.on "active_switch", (data) ->
         console.log "ACTIVE: ", data

      socket.on "location_change", (data) ->
         console.log "LOC: ", data

   app.get "/admin", (req, res, next) ->
      res.render "admin", 
         active: false

   return app

