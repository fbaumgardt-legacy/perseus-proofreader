git = new require('nodegit')
fs = require('fs')
libpath = require('path')
libxml = require('libxmljs')

commit = (res,repopath,filepath) ->
  git.Repo.open(repopath,(error,repo) ->
    res.send 500 if error
    repo.openIndex((error,index) ->
      res.send 500 if error
      index.addByPath(filepath, (error) ->
        res.send 500 if error
        index.write((error) ->
          res.send 500 if error
          index.writeTree((error,oid) ->
            res.send 500 if error
            git.Reference.oidForName(repo,'HEAD',(error,head) ->
              res.send 500 if error
              repo.getCommit(head,(error,parent) ->
                res.send 500 if error
                author = git.Signature.now(res.locals.username,res.locals.email)
                repo.createCommit('HEAD',author,author,res.locals.msg,oid,[parent],(error,cid) -> if error then res.send 500 else res.send("#{cid.sha()}")
                )
              )
            )
          )
        )
      )
    )
  )

write = (req,res) ->
  res.locals.work = req.params.work
  res.locals.page = req.params.page
  res.locals.username = req.body.username
  res.locals.email = req.body.email
  res.locals.msg = req.body.msg
  repopath = libpath.join(req.repository,libpath.dirname(req.index.filter((x) -> x.hash is req.params.work)[0].path),".git")
  filepath = libpath.join(libpath.basename(req.index.filter((x) -> x.hash is req.params.work)[0].path),"p"+('000'+req.params.page)[-4..]+".html")
  writepath = libpath.join(req.repository,libpath.dirname(req.index.filter((x) -> x.hash is req.params.work)[0].path),filepath)
  fs.writeFile(writepath, req.xml.toString(), (error) ->
    res.send 500 if error
    commit(res,repopath,filepath)
  )

module.exports =
  write: write