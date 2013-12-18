libfs = require('fs')
libpath = require('path')
libcrypto = require('crypto')
libxml = require('libxmljs')
Array::last = -> @[@length - 1]

dirsIn = (path) -> libfs.readdirSync(path).filter (x) -> libfs.statSync(libpath.join(path,x)).isDirectory() and x[0] isnt '.'
filesIn = (path,exts) -> libfs.readdirSync(path).filter (x) -> x[x.lastIndexOf('.')..] in exts and x[0] isnt '.'

parser =
  sax: do libxml.SaxParser
  temp: []
  json: {doc:{},index:{}}

parser.sax.on 'startDocument',() ->
  parser.temp= [{children:[]}]

parser.sax.on 'startElementNS',(name,attrs) ->
  attr = {}; attr[x[0]] = x[3] for x in attrs
  element =
    tag:name
    attributes:attr
    children:[]
  parser.temp.last().children.push(element)
  # dirty hack to hardcode name value in function for later serialization:
  parser.temp.last()[name] = new Function("i","var chldrn;chldrn = this.children.filter(function(x) {return x.tag === \"#{name}\";});if (i != null) {return chldrn[i];} else {return chldrn;}")
  parser.temp.push(element)

parser.sax.on 'characters',(chars) ->
  parser.temp.last().text = chars unless /\n/.test(chars)

parser.sax.on 'endElementNS', (name) ->
  parser.temp.pop()

parser.sax.on 'endDocument', () ->
  parser.json.doc[parser.temp.last().children[0].tag] = parser.temp.pop().children[0]

parser.sax.on 'error', () ->

parser.run = (string) ->
  parser.sax.parseString string
  parser.json

module.exports =
  worksIn: (repo) ->
    result = {byName:{},byHash:{}}
    (result.byName[r] = libcrypto.createHash('md5').update(r).digest('hex')[..7]) for r in dirsIn(repo).filter (x) -> x[-5..] is '.book'
    result.byHash[result.byName[value]] = value for value of result.byName
    result
  pagesIn: (work) ->
    filesIn(work,['.html'])
  saxParser: parser