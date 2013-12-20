utils = require('./utils')
libpath = require('path')

module.exports =
  load: (req,res,next) ->
    req.work = res.locals.work = req.index.byHash[req.params.work]
    path = libpath.join(req.repository,req.work)
    req.pages = res.locals.pages = utils.pagesIn(path).map (x) -> x[1..-6].replace(/^0+/, "")
    next()

  show: (req,res) ->
    res.render('work')