Controller = require 'controllers/base/controller'

PanelHeader = require 'views/panel/header'
PannelSidebar = require 'views/panel/sidebar'
PanelMain = require 'views/panel/home'

# Control Panel Home
module.exports = class HomeController extends Controller
  needPermit: 'panel'
  beforeAction: ->
    super
    @compose 'header', PanelHeader, region: 'header'
    @compose 'sidebar', PannelSidebar, region: 'sidebar'

  index: ->
    @view = new PanelMain region: 'main'
