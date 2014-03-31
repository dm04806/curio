View = require 'views/base/view'
mediator = require 'mediator'


EVENT_TYPES = ['subscribe', 'unsubscribe', 'click']

module.exports = class MessageItemView extends View
  template: require './templates/item'
  noWrap: true
  context: ->
    media: mediator.media
    isEventMsg: @isEventMsg()
  isEventMsg: ->
    @model.get('content_type') in EVENT_TYPES
