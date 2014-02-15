PanelSidebar = require 'views/common/sidebar'

navItems = [
  name: 'super.home'
  url: '/super'
  strict: true
  icon: 'home'
,
  name: 'medias.title'
  url: '/super/medias'
  icon: 'media'
,
  name: 'users.title'
  url: '/super/users'
  icon: 'users'
]


module.exports = class SuperSidebar extends PanelSidebar
  navItems: navItems
