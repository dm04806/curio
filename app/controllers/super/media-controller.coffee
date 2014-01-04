SuperHome = require './home-controller'

MediaListView = require 'views/super/media/list'

module.exports = class MediaHome extends SuperHome

  index: ->
    @view = new MediaListView region: 'main'
