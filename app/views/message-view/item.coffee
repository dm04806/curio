View = require 'views/base/view'
mediator = require 'mediator'


module.exports = class MessageItemView extends View
  template: require './templates/item'
  noWrap: true
  context: ->
    try
      tmpl = "./templates/content/#{@model.get 'content_type'}"
      content_tmpl = require tmpl
    media: mediator.media.serialize()
    content_tmpl: content_tmpl
    isEventMsg: @model.isEventMsg()
    eventLine: @model.eventLine()
