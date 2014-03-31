HomeController = require './home-controller'
MessageIndexView = require 'views/message-view'
mediator = require 'mediator'

# Control Panel Home
module.exports = class MessageController extends HomeController
  index: (params, route, opts) ->
    params = opts.query
    params.type = 'incoming'
    params.include = 'subscriber'
    @view = new MessageIndexView
      region: 'main'
      collection: mediator.media.related 'messages', params
