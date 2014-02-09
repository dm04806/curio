View = require 'views/base'
MenuView = require 'views/widgets/global_menu'

navItems = [
  name: 'dashboard'
  url: '/'
  strict: true
  icon: 'home'
,
  name: 'messages.title'
  url: '/messages'
  icon: 'chat'
,
  name: 'contacts.title'
  url: '/contacts'
  icon: 'address-book'
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
