inv = require('./util/inventory')

module.exports =
  load: (req,res,next) ->
    req.repository = res.locals.repository = req.app.get('repository')
    req.index = res.locals.index = inv.worksIn(req.repository)
    next()

  show: (req,res) ->
    res.render('index')