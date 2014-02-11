Controller = require 'controllers/base/controller'

SuperHeader = require 'views/super/header'
SuperSidebar = require 'views/super/sidebar'

module.exports = class SuperHome extends Controller
  needPermit: 'super'
  beforeAction: ->
    super
    @reuse 'super-header', SuperHeader, region: 'header'
    @reuse 'super-sidebar', SuperSidebar, region: 'sidebar'

  main: require 'views/super/home'
