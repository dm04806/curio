HomeController = require './home-controller'
ChannelIndex = require 'views/channel-view'
ChannelShow = require 'views/channel-view/show'
Channel = require 'models/channel'
mediator = require 'mediator'

module.exports = class ChannelController extends HomeController
  index: (params, route, opts) ->
    query = opts.query
    query.limit = 18
    collection = mediator.media.related 'channels', query
    collection.fetch().done =>
      @view = new ChannelIndex
        region: 'main'
        collection: collection
  show: (params, route, opts) ->
    model = @model = new Channel {id: params.id, media_id: mediator.media.id}
    model.fetch().then =>
      @view = new ChannelShow
        model: model
