Controller = require 'controllers/base/controller'
mediator = require 'mediator'

PanelHeader = require 'views/common/header'
PannelSidebar = require 'views/common/sidebar'

# Control Panel Home
module.exports = class HomeController extends Controller
  needPermit: 'panel'
  main: require 'views/home-view'
  _beforeAction: ->
    super
    header = @reuse 'header', PanelHeader, region: 'header'
    @reuse 'sidebar', PannelSidebar, region: 'sidebar'
