ResourceController = require 'controllers/base/resource'

SuperHeader = require 'views/super/header'
SuperSidebar = require 'views/super/sidebar'

module.exports = class SuperHome extends ResourceController
  needPermit: 'super'
  pageClass: 'page-super'
  _beforeAction: ->
    super
    @reuse 'super-header', SuperHeader, region: 'header'
    @reuse 'super-sidebar', SuperSidebar, region: 'sidebar'
  MainViews:
    index: require 'views/super/home-view'
