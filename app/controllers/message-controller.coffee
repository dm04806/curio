HomeController = require './home-controller'
MessageIndexView = require 'views/message-view'
mediator = require 'mediator'

module.exports = class MessageController extends HomeController
  # All Dialogs with this media account
  index: (params, route, opts) ->
    params = opts.query
    params.type = 'incoming'
    params.include = 'subscriber'
    collection = mediator.media.related 'messages', params
    collection.fetch().done =>
      @view = new MessageIndexView
        region: 'main'
        collection: collection
