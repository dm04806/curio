HomeController = require './home-controller'
ChannelIndex = require 'views/channel-view'
ChannelShow = require 'views/channel-view/show'
Channel = require 'models/channel'
mediator = require 'mediator'

module.exports = class ChannelController extends HomeController
  index: (params, route, opts) ->
    query = opts.query
    collection = mediator.media.related 'channels', query
    @view = new ChannelIndex
      autoRender: false
      region: 'main'
      collection: collection
    collection.fetch().done =>
      @view.render()
  show: (params, route, opts) ->
    model = @model = mediator.media.related 'channel', params.id
    model.fetch().then =>
      @view = new ChannelShow
        model: model
