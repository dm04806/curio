View = require 'views/base'
mediator = require 'mediator'

module.exports = class HeaderView extends View
  autoRender: true
  noWrap: true
  template: require './templates/header'
  context: ->
    user = mediator.user
    return unless user
    user: user.attributes
    in_super: false
    is_super: user.permitted 'super'
