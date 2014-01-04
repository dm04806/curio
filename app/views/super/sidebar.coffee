PanelSidebar = require 'views/panel/sidebar'

navItems = [
  name: 'home'
  url: '/super'
  icon: 'home'
,
  name: 'medias'
  url: '/super/media'
  icon: 'msg'
,
  name: 'users'
  url: '/super/user'
  icon: 'head'
]


module.exports = class SuperSidebar extends PanelSidebar
  navItems: navItems
