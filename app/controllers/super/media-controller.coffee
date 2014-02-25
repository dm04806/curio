SuperHome = require './home-controller'
MediaIndexView = require 'views/super/media-view'
MediaShow = require 'views/super/media-view/show'
Media = require 'models/media'

module.exports = class MediaHome extends SuperHome
  route: 'super/media'
  MainViews:
    index: MediaIndexView
    show: MediaShow
    create: MediaShow
  Model: Media
  index: (params) ->
    params.include = 'admins'
    super
