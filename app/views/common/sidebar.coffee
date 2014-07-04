View = require 'views/base'
MenuView = require 'views/widgets/global_menu'
mediator = require 'mediator'

navItems = [
  name: 'messages'
  icon: 'bubbles'
  subnav: [
    name: 'messages.recent'
    url: '/messages'
    icon: 'chat'
  ,
    name: 'subscribers'
    url: '/subscribers'
    icon: 'address-book'
  ,
    name: 'rules'
    url: '/rules'
    icon: 'redo'
  ]
,
  name: 'resources'
  icon: 'drawer2'
  subnav: [
    name: 'places'
    url: '/places'
    icon: 'location'
  ,
    name: 'channels'
    url: '/channels'
    icon: 'filter'
  ,
    name: 'menu'
    url: "/menu"
    icon: "map"
  ]
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
  items: navItems
  regions:
    main_menu: '.main-menu'
  template: require './templates/sidebar'
  render: ->
    #@model = mediator.media
    super
    mainMenu = new MenuView
      region: 'main_menu'
      items: @items
    @subview 'main_menu', mainMenu
