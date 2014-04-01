mediator = require 'mediator'
MainView = require 'views/common/main'

module.exports = class HomeMain extends MainView
  template: require './templates/index'
  context: ->
    media: mediator.media.attributes

