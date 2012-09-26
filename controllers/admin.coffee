express = require "express"
rest = require "request"
config = require "../config/app"

app = module.exports = express()

app.get "/", (req, res, next) ->