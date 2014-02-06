PanelHeader = require 'views/panel/header'

module.exports = class SuperHeader extends PanelHeader
  context: ->
    ret = super
    ret.in_super = true
    return ret
