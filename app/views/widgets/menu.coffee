View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'

isActive = (obj, path) ->
  path = path or location.pathname
  url = obj.url.replace(/s$/, '')
  if obj.strict
    path is url
  else
    path.indexOf(url) is 0

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

  getItem: (name) ->
    for item in @items
      if item.name == name
        return item

  getActiveItem: () ->
    for item in @items
      if isActive(item)
        return item

  getActiveNode: (name) ->
    return @$el.find("li[data-name='#{name}']")

  getActiveForRouter: (router, params) ->
    url = utils.reverse router, params
    for item in @items
      if item.route == router.name
        return item
      if isActive(item, url)
        return item

  updateState: (name) ->
    if arguments.length == 4
      [controller, params, router, opts] = arguments
      item = @getActiveForRouter(router, params)
    else
      item = name and getItem(name) or @getActiveItem()
    if not item
      @$el.children().removeClass('active')
      return
    node = @getActiveNode(item.name)
    node.addClass('active').siblings().removeClass('active')
    return
