express = require "express"
config = require "../config/app"
path = require "path"

app = module.exports = express()

# Settings
app.set "view engine", "jade"
app.set "view options", layout: false
app.set "views", path.join __dirname, "../views"

app.configure "development", () ->
   app.use express.logger "dev"
   app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure "production", () ->
   app.use express.errorHandler()

# Middleware
app.use express.query()
app.use express.bodyParser()
app.use require("connect-assets")()
app.use express.static path.join __dirname, "../public"
app.use require "../middleware/utils"

# Controllers
app.use require "./home"
app.use require "./admin"