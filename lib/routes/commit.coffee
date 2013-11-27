git = require('nodegit')

res.locals.json = req.data
res.locals.work = req.params.work
res.locals.page = req.params.page

git.Repo.open('',(error,repo) ->

# get index, add/update file, create commit
)