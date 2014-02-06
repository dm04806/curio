View = require 'views/base'

mediator = Chaplin.mediator

navItems = [
  name: 'home'
  url: '/'
  icon: 'home'
,
  name: 'messages.title'
  url: '/messages'
  icon: 'msg'
,
  name: 'contacts.title'
  url: '/contacts/all'
  icon: 'head'
]

getNavItems = (items) ->
  ret = []
  user = mediator.user
  for nav in items
    role = nav.role
    if role and not user.hasRole(nav.role)
      continue
    obj =
      name: nav.name
      url: nav.url
      icon: nav.icon
    if nav.subnav
      obj.subnav = getNavItems(nav.subnav)
    ret.push(obj)
  return ret


module.exports = class SidebarView extends View
  autoRender: true
  className: 'sidebar-nav'
  navItems: navItems
  context: ->
    nav: getNavItems(@navItems)
  template: require './templates/sidebar'

