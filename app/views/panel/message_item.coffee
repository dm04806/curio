View = require 'views/base/view'
mediator = require 'mediator'

module.exports = class MessageItemView extends View
  template: require './templates/message_item'
  noWrap: true
  context: ->
    media: mediator.media
