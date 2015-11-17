app = require('./app')

app.configure('development', ->
  app.set('repository','./vendor/ogl-data')
  app.set('user','your-github-name-here')
  app.set('email','your-github-email-here')

  app.listen(7070)
)
