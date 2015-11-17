app = require('./app')

app.configure('development', ->
  app.set('repository','./vendor/ogl-data')
  app.set('user','dddgit')
  app.set('email','ddd.git@digitaldividedata.org')

  app.listen(8070)
)
