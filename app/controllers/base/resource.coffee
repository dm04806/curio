Controller = require './controller'
utils = require 'lib/utils'

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
  show: (params) ->
    model = new @Model({ id: params.id })
    model.fetch().then =>
      @view = new @MainViews.show region: 'main', model: model
  create: (params, route) ->
    _.defaults params, utils.queryParams.parse(route.query)
    model = new @Model(params)
    model.on 'sync', () =>
      return unless model.id
      setTimeout =>
        @redirectTo "#{route.name.replace('create', 'show')}", id: model.id
      , 400
    @view = new @MainViews.show region: 'main', model: model
