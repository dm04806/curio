Controller = require 'controllers/base/controller'

PanelHeader = require 'views/panel/header'
PannelSidebar = require 'views/panel/sidebar'

# Control Panel Home
module.exports = class HomeController extends Controller
  needPermit: 'panel'
  beforeAction: ->
    return if super
    @compose 'header', PanelHeader, region: 'header'
    @compose 'sidebar', PannelSidebar, region: 'sidebar'

  main: require 'views/panel/home'
