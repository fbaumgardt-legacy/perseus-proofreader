fs = require 'fs'
path = require 'path'
parsing = require './parsing'

dirsIn = (path) -> fs.readdirSync(path).filter (x) -> fs.statSync(path.join(path,x)).isDirectory() and x[0] isnt '.'
filesIn = (path,exts) -> fs.readdirSync(path).filter (x) -> x[x.lastIndexOf('.')..] in exts and x[0] isnt '.'

module.exports =
  worksIn: (repo) ->
    filesIn(path.join(repo,"inventory"),[".json"]).map((x) -> JSON.parse(fs.readFileSync(path.join(repo,"inventory",x),"utf8"))).reverse()
  pagesIn: (work) ->
    JSON.parse(fs.readFileSync(path.join(work,"inventory.json"),"utf8"))
  inventory: (dir) ->
    pages = pagesIn(dir)
    pages.map (x) -> parsing.page2score.run(fs.readFileSync x)
