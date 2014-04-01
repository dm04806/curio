HomeController = require './home-controller'
SubscriberIndexView = require 'views/subscriber-view/index'
SubscriberShow = require 'views/subscriber-view/show'
mediator = require 'mediator'
Subscriber = require 'models/subscriber'
Message = require 'models/message'

# Control Panel Home
module.exports = class SubscriberController extends HomeController
  index: (params) ->
    params.include = 'props'
    collection = mediator.media.related 'subscribers', params
    @view = new SubscriberIndexView
      region: 'main'
      collection: collection
  show: (params, route, opts) ->
    media = mediator.media
    model = @model = media.related 'subscriber', params.id
    query = opts.query
    query.subscriber_id = params.id
    collection = media.related 'messages', query
    collection.subscriber = model
    model.fetch().then =>
      @view = new SubscriberShow
        collection: collection
        model: model
