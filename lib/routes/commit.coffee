git = require('nodegit')

res.locals.json = req.data
res.locals.work = req.params.work
res.locals.page = req.params.page

git.Repo.open('../vendor/ogl-data/.git',(error,repo) ->
  if (error) throw error

  repo.getIndex
  # get index, add/update file, create commit
)