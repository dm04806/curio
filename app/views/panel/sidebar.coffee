View = require 'views/base'

navItems = [
  name: 'home'
  url: '/'
  icon: 'home'
,
  name: 'messages'
  url: '/messages'
  icon: 'msg'
,
  name: 'contacts'
  url: '/contacts/all'
  icon: 'head'
]

module.exports = class SidebarView extends View
  autoRender: true
  className: 'sidebar-nav'
  context:
    nav: navItems
  template: require './templates/sidebar'

