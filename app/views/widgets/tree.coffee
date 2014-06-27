View = require 'views/base'
utils = require 'lib/utils'

module.exports = class TreeView extends View
  tagName: 'ul'
  className: 'tree'
  render: ->
    super
