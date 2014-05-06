HomeController = require './home-controller'
PlaceIndex = require 'views/place-view'
PlaceShow = require 'views/place-view/show'
Place = require 'models/place'
mediator = require 'mediator'

module.exports = class PlaceController extends HomeController
  index: (params, route, opts) ->
    query = opts.query
    query.limit = 18
    collection = mediator.media.related 'places', query
    collection.fetch().done =>
      @view = new PlaceIndex
        region: 'main'
        collection: collection
  show: (params, route, opts) ->
    model = @model = new Place {id: params.id, media_id: mediator.media.id}
    model.fetch().then =>
      @view = new PlaceShow
        model: model
  create: (params, route, opts) ->
    model = @model = new Place { media_id: mediator.media.id }
    @view = new PlaceShow
      model: model
