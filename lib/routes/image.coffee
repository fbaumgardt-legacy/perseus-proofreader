fs = require('fs')
path = require('path')

module.exports =
  load: (req,res,next) ->
    dir = path.join(req.repository,req.index.filter((x) -> x.hash is req.params.work)[0].path)
    filepath = path.join(dir,"i"+('000'+req.params.page)[-4..]+".jpg")
    req.image = res.locals.image = fs.readFileSync(filepath)
    next()

  show: (req,res) ->
    res.writeHead(200, {'Content-Type': 'image/jpeg'});
    res.end(req.image);