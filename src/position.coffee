_           = require('lodash')
ScribeDOM   = require('./dom')
ScribeUtils = require('./utils')


class ScribePosition
  @findLeafNode: (editor, node, offset) ->
    [node, offset] = ScribeUtils.findDeepestNode(node, offset)
    if node.nodeType == ScribeDOM.TEXT_NODE
      offset = ScribePosition.getIndex(node, offset, node.parentNode)
      node = node.parentNode
    return [node, offset]

  @getIndex: (node, index = 0, offsetNode = null) ->
    while node != offsetNode and node.ownerDocument? and !ScribeDOM.hasClass(node, 'editor')
      while node.previousSibling?
        node = node.previousSibling
        index += ScribeUtils.getNodeLength(node)
      node = node.parentNode
    return index


  # constructor: (Editor editor, Object node, Number offset) ->
  # constructor: (Editor editor, Number index) ->
  constructor: (@editor, @leafNode, @offset) ->
    if _.isNumber(@leafNode)
      @offset = @index = @leafNode
      @leafNode = @editor.root
    else
      @index = ScribePosition.getIndex(@leafNode, @offset)
    [@leafNode, @offset] = ScribePosition.findLeafNode(@editor, @leafNode, @offset)

  getLeaf: ->
    return @leaf if @leaf?
    @leaf = @editor.doc.findLeaf(@leafNode)
    return @leaf

  getIndex: ->
    return ScribePosition.getIndex(@leafNode, @offset, @editor.root)


module.exports = ScribePosition