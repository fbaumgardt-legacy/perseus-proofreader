app = require('./app')

app.configure('development', ->
  app.set('repository','./vendor/ogl-data')

  app.listen(7070)
)