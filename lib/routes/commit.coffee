git = require('nodegit')
fs = require('fs')
libpath = require('path')

commit = (repopath,filepath) ->
  git.Repo.open(repopath,(error,repo) ->
    if (error)
      res.send(500)
    repo.openIndex((error,index) ->
      if (error)
        res.send(500)
      index.addByPath(filepath, (error) ->
        if (error)
          res.send(500)
        index.write((error) ->
          if (error)
            res.send(500)
          else
            res.send(200)
        )
      )
    )
  )

write = (req,res) ->
  res.locals.json = req.data
  res.locals.work = req.params.work
  res.locals.page = req.params.page
  repopath = libpath.join(req.repository,".git")
  filepath = libpath.join(req.index.byHash[req.params.work],"p"+('000'+req.params.page)[-4..]+".html")
  writepath = libpath.join(req.repository,filepath)
  fs.writeFile(writepath, req.data, (error) ->
    if (error)
      res.send(500)
    commit(repopath,filepath)
  )

module.exports =
  write: write