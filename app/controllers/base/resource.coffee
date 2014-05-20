Controller = require './controller'
utils = require 'lib/utils'
common = require 'views/common/utils'

module.exports = class ResourceController extends Controller
  MainViews:
    index: null
    show: null
    create: null
  Model: null

  index: (params, route, options) ->
    params = _.assign(options.query, params)
    @view = new @MainViews.index
      region: 'main'
      params: params
    @view.route = route

  show: (params, route, options) ->
    model = new @Model(params)
    model.fetch().then =>
      @view = new @MainViews.show
        region: 'main'
        data: options
        model: model

  create: (params, route, options) ->
    _.defaults params, options.query
    model = new @Model(params)
    model.on 'sync', =>
      return unless model.id
      setTimeout =>
        @redirectTo "#{route.name.replace('create', 'show')}", {id: model.id}, {from: 'create'}
      , 500
    View = @MainViews.create or @MainViews.show
    @view = new View region: 'main', model: model
