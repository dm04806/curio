HomeController = require './home-controller'
SubscriberIndexView = require 'views/subscriber-view/index'
SubscriberShow = require 'views/subscriber-view/show'
mediator = require 'mediator'
Subscriber = require 'models/subscriber'
Message = require 'models/message'

# Control Panel Home
module.exports = class SubscriberController extends HomeController
  index: (params, route, opts) ->
    query = opts.query
    query.include = 'props,tags'
    collection = mediator.media.related 'subscribers', query
    collection.fetch().then =>
      @view = new SubscriberIndexView
        region: 'main'
        collection: collection
  # messages with this subscriber
  show: (params, route, opts) ->
    media = mediator.media
    model = @model = media.related 'subscriber', params.id
    query = opts.query
    query.subscriber_id = params.id
    collection = media.related 'messages', query
    collection.subscriber = model
    $.when(model.fetch(), collection.fetch()).then =>
      @view = new SubscriberShow
        region: 'main'
        collection: collection
        model: model
