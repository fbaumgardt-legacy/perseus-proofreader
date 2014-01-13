libxml = require('libxmljs')
Array::last = -> @[@length - 1]

xml2json =
  sax: do libxml.SaxParser
  json: {doc:{},index:{}}
  temp: []
  run: (string) ->
    xml2json.sax.parseString string
    xml2json.json

xml2json.sax.on 'startDocument',() ->
  xml2json.temp= [{children:[]}]
xml2json.sax.on 'startElementNS',(name,attrs) ->
  attr = {}; attr[x[0]] = x[3] for x in attrs
  element =
    tag:name
    attributes:attr
    children:[]
  xml2json.temp.last().children.push(element)
  # dirty hack to hardcode name value in function for later serialization:
  xml2json.temp.last()[name] = new Function("i","var chldrn;chldrn = this.children.filter(function(x) {return x.tag === \"#{name}\";});if (i != null) {return chldrn[i];} else {return chldrn;}")
  xml2json.temp.push(element)
xml2json.sax.on 'characters',(chars) ->
  xml2json.temp.last().text = chars unless /\n/.test(chars)
xml2json.sax.on 'endElementNS', (name) ->
  xml2json.temp.pop()
xml2json.sax.on 'endDocument', () ->
  xml2json.json.doc[xml2json.temp.last().children[0].tag] = xml2json.temp.pop().children[0]
xml2json.sax.on 'error', () ->

page2score =
  sax: do libxml.SaxParser
  temp: []
  run: (string) ->
    page2score.sax.parseString string
    page2score.temp

page2score.sax.on 'startDocument',() ->
  page2score.temp = []
page2score.sax.on 'startElementNS',(name,attrs) ->
  if (name is 'ins')
    page2score.temp.push attrs.filter((x) -> x[0] is 'title')[0][3][4..]
page2score.sax.on 'error', () ->

module.exports =
  xml2json: xml2json
  page2score: page2score