View = require 'views/base'
MenuView = require 'views/widgets/global_menu'
mediator = require 'mediator'

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
  name: 'subscribers'
  url: '/subscribers'
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
    #@model = mediator.media
    super
    mainMenu = new MenuView
      region: 'main_menu'
      items: @navItems
    @subview 'main_menu', mainMenu
