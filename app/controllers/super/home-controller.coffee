Controller = require 'controllers/base/controller'

SuperHeader = require 'views/panel/header'
SuperSidebar = require 'views/super/sidebar'

module.exports = class SuperHome extends Controller
  needPermit: 'super'
  beforeAction: ->
    return if super
    @compose 'super.header', SuperHeader, region: 'header'
    @compose 'super.sidebar', SuperSidebar, region: 'sidebar'

  main: require 'views/super/home'
