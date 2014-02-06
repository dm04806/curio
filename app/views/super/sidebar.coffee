PanelSidebar = require 'views/panel/sidebar'

navItems = [
  name: 'home'
  url: '/super'
  icon: 'home'
,
  name: 'medias.title'
  url: '/super/medias'
  icon: 'msg'
,
  name: 'users.title'
  url: '/super/users'
  icon: 'head'
]


module.exports = class SuperSidebar extends PanelSidebar
  navItems: navItems
