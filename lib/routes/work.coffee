inv = require('./util/inventory')
path = require('path')

module.exports =
  load: (req,res,next) ->
    req.work = res.locals.work = req.index.filter((x) ->x.hash is req.params.work)[0]
    req.pages = res.locals.pages = inv.pagesIn(path.join(req.repository,req.work.path))
    next()

  show: (req,res) ->
    res.render('work')