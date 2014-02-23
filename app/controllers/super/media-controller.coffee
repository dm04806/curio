SuperHome = require './home-controller'
MediaIndexView = require 'views/super/media_index'
MediaShow = require 'views/super/media_show'
Media = require 'models/media'

module.exports = class MediaHome extends SuperHome
  index: (params, route, options) ->
    params.include = 'admins'
    @view = new MediaIndexView region: 'main', params: params
  show: (params) ->
    model = new Media({ id: params.id })
    model.fetch().then =>
      @view = new MediaShow region: 'main', model: model
  create: (params) ->
    model = new Media(params)
    model.on 'sync', () =>
      if model.id
        setTimeout =>
          @redirectTo 'super/media#show', id: model.id
        , 400
    @view = new MediaShow region: 'main', model: model
