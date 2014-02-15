View = require 'views/base'
MenuView = require 'views/widgets/global_menu'

navItems = [
  name: 'dashboard'
  url: '/'
  strict: true
  icon: 'home'
,
  name: 'messages'
  url: '/messages'
  icon: 'bubbles'
,
  name: 'contacts'
  url: '/contacts'
  icon: 'address-book'
,
  name: 'stats'
  url: '/stats'
  icon: 'stats'
,
  name: 'channels'
  url: '/channels'
  icon: 'filter'
]

module.exports = class SidebarView extends View
  autoRender: true
  className: 'sidebar-nav'
  navItems: navItems
  regions:
    main_menu: '.main-menu'
  template: require './templates/sidebar'
  render: ->
    super
    mainMenu = new MenuView
      region: 'main_menu'
      items: @navItems
    @subview 'main_menu', mainMenu
