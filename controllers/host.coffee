express = require "express"
config = require "../config/app"
path = require "path"
http = require "http"
passport = require "passport"
mongoose = require "mongoose"
RedisStore = require("connect-redis")(express)
redis = require("redis-url")
User = require "../models/User"

app = express()

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
app.use express.cookieParser process.env.COOKIE_SECRET or "super duper secret"
app.use require("connect-assets")()
app.use express.static path.join __dirname, "../public"
app.use require("../middleware/utils").root

#Session

sessionStore =  new RedisStore
   client: redis.connect process.env.REDISTOGO_URL
app.use express.session
   cookie:
      maxAge: 60000 * 2880
   store: sessionStore

# Passport
app.use passport.initialize()
app.use passport.session()

# Socket.io
module.exports = server = http.createServer(app)
io = require("socket.io").listen(server)

# Mongoose
mongoose.connect process.env.MONGOHQ_URL
mongoose.connection.on "open", () ->
   console.log "Mongoose connected."

# Controllers
app.use require("./home")(null)
app.use require("./admin")(io, sessionStore)

# Passport
passport.serializeUser (user, done) ->
   done null, user.id

passport.deserializeUser (id, done) ->
   User.findOne _id: id, done