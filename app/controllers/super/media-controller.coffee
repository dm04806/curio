SuperHome = require './home-controller'
MediaIndexView = require 'views/super/media_index'
MediaShow = require 'views/super/media_show'
Media = require 'models/media'

module.exports = class MediaHome extends SuperHome
  index: (params, route, options) ->
    @view = new MediaIndexView region: 'main', params: params
  show: (params) ->
    model = new Media({ id: params.id })
    model.fetch().then =>
      @view = new MediaShow region: 'main', model: model
