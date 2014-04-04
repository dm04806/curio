View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'

isActive = (obj, path) ->
  return if not obj.url
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



menuFolded = (name) ->
  return utils.store "menu-fold-flag:#{name}"


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
    return if @disposed
    for subview in @subviews
      subview.updateState(arguments...)
    if arguments.length == 4
      [controller, params, router, opts] = arguments
      item = @getActiveForRouter(router, params)
    else
      item = name and getItem(name) or @getActiveItem()
    if not item
      @$el.children().removeClass('active')
      return
    node = @getActiveNode(item.name)
    if node.find('.nav').length
      # has subnav, only need to set subnav active
      return
    node.addClass('active').siblings().removeClass('active')
    return

  getItemNode: (name) ->
    name = name.name or name
    return @$el.find("[data-name=#{name}]")

  render: ->
    super
    @items.forEach (item) =>
      if item.subnav
        # render subnav
        subnav = new MenuView
          items: item.subnav
          container: @getItemNode(item)
        @subview "submenu-#{item.name}", subnav
        setTimeout ->
          subnav.$el
            .height(subnav.$el.height())
            .addClass('foldable')
          if menuFolded(item.name)
            subnav.$el.addClass('folded')

  toggleSubnav: (e) ->
    node = $(e.target).parent()
    subnav = node.find('.nav')
    subnav.toggleClass('folded')
    name = node.data('name')
    key = "menu-fold-flag:#{name}"
    if subnav.hasClass('folded')
      utils.store key, 1
    else
      utils.store.remove key

  events:
    'click .toggler': 'toggleSubnav'
