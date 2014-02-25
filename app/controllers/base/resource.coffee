Controller = require './controller'

module.exports = class ResourceController extends Controller
  MainViews:
    index: null
    show: null
    create: null
  Model: null
  route: null
  index: (params, route, options) ->
    @view = new @MainViews.index region: 'main', params: params
  show: (params) ->
    model = new @Model({ id: params.id })
    model.fetch().then =>
      @view = new @MainViews.show region: 'main', model: model
  create: (params) ->
    model = new @Model(params)
    model.on 'sync', () =>
      return unless model.id
      setTimeout =>
        @redirectTo "#{@route}#show", id: model.id
      , 400
    @view = new @MainViews.show region: 'main', model: model
