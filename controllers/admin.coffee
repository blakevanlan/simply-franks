express = require "express"
rest = require "request"
config = require "../config/app"
passport = require "passport"
LocalStrategy = require("passport-local").Strategy
mongoose = require "mongoose"
authenticate = require("../middleware/utils").authenticate
User = require "../models/User"

passport.use new LocalStrategy (username, password, done) ->
   User.findOne
      username: username
      password: password
      , (error, user) ->
         if user then done null, user
         else done null, false, message: "Invalid username and password."

module.exports = (io, session) ->
   app = express()

   io.sockets.on "connection", (socket) ->
      
      socket.on "active_switch", (data) ->
         session.get data.session_id, (error, session_data) ->
            return if error
            User.findOne _id: session_data.passport.user, (error, user) ->
               user.active = data.active
               user.save()

      socket.on "location_change", (data) ->
         session.get data.session_id, (error, session_data) ->
            return if error
            User.findOne _id: session_data.passport.user, (error, user) ->
               user.lat = data.lat
               user.lng = data.lng
               user.save()
               socket.emit "location_update", 
                  lat: data.lat
                  lng: data.lng

   app.get "/login", (req, res, next) ->
      if req.user then return res.redirect "/admin"
      res.render "login"

   app.post "/login", passport.authenticate("local", 
      successRedirect: "/admin"
      failureRedirect: "/login"
      failureFlash: false)

   app.get "/admin", authenticate, (req, res, next) ->
      res.render "admin", 
         active: req.user.active
         connect_sid: req.sessionID

   return app

