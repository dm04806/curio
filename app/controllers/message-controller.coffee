HomeController = require './home-controller'
MessageIndexView = require 'views/panel/message_index'
mediator = require 'mediator'

# Control Panel Home
module.exports = class MessageController extends HomeController
  index: (params) ->
    collection = mediator.media.related 'messages', params
    @view = new MessageIndexView region: 'main', collection: collection
    collection.fetch()
