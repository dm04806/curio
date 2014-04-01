HomeController = require './home-controller'
mediator = require 'mediator'

SettingsIndex = require 'views/settings-view'

module.exports = class SettingsController extends HomeController
  index: ->
    @view = new SettingsIndex
      model: mediator.media


