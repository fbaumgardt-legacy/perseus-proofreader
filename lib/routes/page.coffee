libfs = require('fs')
libpath = require('path')
utils = require('./utils')

module.exports =
  load: (req,res,next) ->
    res.locals.page = req.params.page;
    file = libpath.join(req.repository,req.index.byHash[req.params.work],"p"+('000'+req.params.page)[-4..]+".html")
    req.json = res.locals.json = utils.saxParser.run libfs.readFileSync(file,'utf8')
    next()

  show: (req,res) ->
    res.render('page')