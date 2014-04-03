View = require 'views/base'
MenuView = require 'views/widgets/global_menu'
mediator = require 'mediator'

navItems = [
  name: 'messages'
  url: '/messages'
  icon: 'bubbles'
,
  name: 'subscribers'
  url: '/subscribers'
  icon: 'address-book'
,
  name: 'channels'
  url: '/channels'
  icon: 'filter'
,
  name: 'Locations'
  url: '/places'
  icon: 'location'
,
  name: 'stats'
  url: '/stats'
  icon: 'stats'
,
  name: 'settings'
  url: '/settings'
  icon: 'cog2'
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
