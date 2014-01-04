Controller = require 'controllers/base/controller'


SuperHeaderView = require 'views/pannel/header'
SuperNavView = require 'views/super/nav'
SuperHomeMain = require 'views/super/home'

# Control Pannel Home
module.exports = class HomeController extends Controller
  needPermit: 'super'
  beforeAction: ->
    super
    @compose 'header', SuperHeaderView, region: 'header'
    @compose 'nav', SuperNavView, region: 'sidebar'

  index: ->
    @view = new SuperHomeMain region: 'main'
