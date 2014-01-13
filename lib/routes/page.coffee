fs = require('fs')
path = require('path')
parsing = require('./util/parsing')

module.exports =
  load: (req,res,next) ->
    res.locals.page = req.params.page;
    dir = path.join(req.repository,req.index.filter((x) -> x.hash is req.params.work)[0].path)
    file = path.join(dir,"p"+('000'+req.params.page)[-4..]+".html")
    req.json = res.locals.json = parsing.xml2json.run fs.readFileSync(file,'utf8')
    next()

  show: (req,res) ->
    res.render('page')