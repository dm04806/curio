Controller = require 'controllers/base/controller'
mediator = require 'mediator'

PanelHeader = require 'views/common/header'
PannelSidebar = require 'views/common/sidebar'
HomeMain = require 'views/home-view'

# Control Panel Home
module.exports = class HomeController extends Controller
  needPermit: 'panel'
  _beforeAction: ->
    super
    header = @reuse 'header', PanelHeader, region: 'header'
    @reuse 'sidebar', PannelSidebar, region: 'sidebar'
  index: ->
    mediator.media.load 'stats/homepage', (err, res) =>
      @view = new HomeMain { data: res }

