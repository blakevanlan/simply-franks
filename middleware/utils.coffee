path = require "path"

module.exports =
   # Add root to locals to allow for page specific body class
   root: (req, res, next) ->
      res.locals.root = path.resolve __dirname, "../views"
      next()
   authenticate: (req, res, next) ->
      if req.user then next()
      else res.redirect "/login"