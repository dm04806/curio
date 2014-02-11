Controller = require 'controllers/base/controller'
mediator = require 'mediator'

PanelHeader = require 'views/panel/header'
PannelSidebar = require 'views/panel/sidebar'

# Control Panel Home
module.exports = class HomeController extends Controller
  needPermit: 'panel'
  beforeAction: ->
    super # exit when super has error
    header = @reuse 'header', PanelHeader, region: 'header'
    @reuse 'sidebar', PannelSidebar, region: 'sidebar'

  main: require 'views/panel/home'
