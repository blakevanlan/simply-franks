module.exports = (error, req, res, next) ->
   console.error error.stack
   res.render "error"   