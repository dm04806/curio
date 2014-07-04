HomeController = require 'controllers/home-controller'
mediator = require 'mediator'


Media = require 'models/media'
MediaShow = require 'views/super/media-view/show'

# Control Panel Home
module.exports = class WizardController extends HomeController
  needPermit: 'user'
  index: ->
    model = new Media
    @view = new MediaShow model: model
    model.on 'sync', =>
      return unless model.id
      window.location = '/'


