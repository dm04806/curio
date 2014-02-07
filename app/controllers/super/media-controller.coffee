SuperHome = require './home-controller'
MediaListView = require 'views/super/media/index'
Media = require 'models/media'

module.exports = class MediaHome extends SuperHome
  index: (params, route, options) ->
    @view = new MediaListView region: 'main', params: params
  show: ->
    @view = new MediaItemView region: 'main'
