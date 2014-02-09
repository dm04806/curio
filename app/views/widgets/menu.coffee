View = require 'views/base'
mediator = require 'mediator'

isActive = (obj) ->
  path = location.pathname
  return path is obj.url if obj.strict
  path.indexOf(obj.url) is 0

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


module.exports = class MenuView extends View
  autoRender: true
  items: []
  optionNames: View::optionNames.concat ['items']
  className: 'nav nav-pills nav-stacked'
  tagName: 'ul'
  template: require './templates/menu'
  context: ->
    nav: getNavItems(@items)
  getActiveItem: () ->
    for item in @items
      if isActive(item)
        return item
  getActiveNode: (name) ->
    return @$el.find("li[data-name='#{name}']")
  updateState: (name) ->
    if name and name.currentTarget
      node = $(name.currentTarget)
    else if 'string' isnt typeof name
      item = @getActiveItem()
      return unless item
      name = item.name
    node = @getActiveNode(name)
    node.addClass('active').siblings().removeClass('active')
  render: ->
    super
    @updateState()
  events:
    'click li': 'updateState'
