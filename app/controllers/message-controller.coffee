HomeController = require './home-controller'
MessageIndexView = require 'views/message-view'
mediator = require 'mediator'

module.exports = class MessageController extends HomeController
  # Dialog with xxx, message list
  index: (params, route, opts) ->
    params = opts.query
    params.type = 'incoming'
    params.include = 'subscriber'
    @view = new MessageIndexView
      region: 'main'
      collection: mediator.media.related 'messages', params
