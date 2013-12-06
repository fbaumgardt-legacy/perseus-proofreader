fs = require('fs')
path = require('path')

module.exports =
  load: (req,res,next) ->
    filepath = path.join(req.repository,req.index.byHash[req.params.work],"i"+('000'+req.params.page)[-4..]+".jpg")
    req.image = res.locals.image = fs.readFileSync(filepath)
    next()

  show: (req,res) ->
    res.writeHead(200, {'Content-Type': 'image/jpeg'});
    res.end(req.image);