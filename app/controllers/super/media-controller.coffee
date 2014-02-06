SuperHome = require './home-controller'
MediaListView = require 'views/super/media/index'

module.exports = class MediaHome extends SuperHome
  index: ->
    @view = new MediaListView region: 'main'
  show: ->
    @view = new MediaItemView region: 'main'
