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
                author = git.Signature.now(res.locals.name,res.locals.email)
                repo.createCommit('HEAD',author,author,res.locals.msg,oid,[parent],(error,cid) ->
                  res.send 500 if error
                  res.send("Successful commit: #{cid.sha()}")
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
  res.locals.name = req.body.name
  res.locals.email = req.body.email
  res.locals.msg = req.body.msg
  repopath = libpath.join(req.repository,".git")
  filepath = libpath.join(req.index.byHash[req.params.work],"p"+('000'+req.params.page)[-4..]+".1.html")
  writepath = libpath.join(req.repository,filepath)
  fs.writeFile(writepath, req.xml.toString(), (error) ->
    res.send 500 if error
    commit(res,repopath,filepath)
  )

module.exports =
  write: write