Controller = require 'controllers/base/controller'

SuperHeader = require 'views/super/widgets/header'
SuperSidebar = require 'views/super/widgets/sidebar'

module.exports = class SuperHome extends Controller
  needPermit: 'super'
  _beforeAction: ->
    super
    @reuse 'super-header', SuperHeader, region: 'header'
    @reuse 'super-sidebar', SuperSidebar, region: 'sidebar'

  main: require 'views/super/home'
