libxml = require('libxmljs')

toXML = (parent,obj) ->
  node = parent.node(obj.tag)
  if obj.attributes? then node.attr(obj.attributes)
  if obj.text? then node.text(obj.text)
  if obj.children? then obj.children.forEach((child) -> toXML(node,child))

module.exports =
  do: (req,res,next) ->
    req.xml = res.locals.xml = new libxml.Document()
    toXML(req.xml,req.body)
    next()