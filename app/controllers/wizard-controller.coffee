Controller = require 'controllers/base/controller'
mediator = require 'mediator'


Media = require 'models/media'
MediaShow = require 'views/super/media-view/show'

PanelHeader = require 'views/common/header'
PanelSidebar = require 'views/common/sidebar'
PannelSidebar = require 'views/common/sidebar'


# Control Panel Home
module.exports = class WizardController extends Controller
  needPermit: 'user'
  _beforeAction: ->
    super
    @reuse 'header', PanelHeader, region: 'header'
    @reuse 'sidebar', PannelSidebar,
      region: 'sidebar'
      items: []
  index: ->
    model = new Media
    @view = new MediaShow model: model
    model.on 'sync', =>
      return unless model.id
      window.location = '/'


