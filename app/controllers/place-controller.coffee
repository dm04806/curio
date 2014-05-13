ResourceController = require './base/resource'
HomeController = require './home-controller'

PlaceIndex = require 'views/place-view'
PlaceShow = require 'views/place-view/show'
Place = require 'models/place'
mediator = require 'mediator'

module.exports = class PlaceController extends ResourceController
  MainViews:
    index: PlaceIndex
    show: PlaceShow
  Model: Place
  needPermit: 'panel'
  _beforeAction: HomeController::_beforeAction
  index: (params, route, opts) ->
    query = opts.query
    query.limit = 18
    collection = mediator.media.related 'places', query
    collection.fetch().done =>
      @view = new PlaceIndex
        region: 'main'
        collection: collection
  show: (params) ->
    arguments[0] = { id: params.id, media_id: mediator.media.id }
    super
  create: (params, route, opts) ->
    arguments[0] = { media_id: mediator.media.id }
    super
