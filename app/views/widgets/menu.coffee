View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'


##
# Filter nav items by user role
#
filterNavItems = (items) ->
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
      obj.subnav = filterNavItems(nav.subnav)
    ret.push(obj)
  return ret


module.exports = class MenuView extends View
  autoRender: true
  className: 'nav nav-pills nav-stacked'
  tagName: 'ul'
  template: require './templates/menu'
  context: ->
    nav: filterNavItems(@items)

  getItem: (name) ->
    for item in @items
      if item.name == name
        return item

  isActive: (obj, path) ->
    return if not obj.url
    path = path or location.pathname
    url = obj.url.replace(/s$/, '')
    if '?' in url
      # if has querystring, must match all
      return location.pathname + location.search == obj.url
    if obj.strict
      path is url
    else
      path.indexOf(url) is 0

  getActiveItem: () ->
    for item in @items
      if @isActive(item)
        return item

  getActiveNode: () ->
    return @getItemNode @getActiveItem()

  getActiveForRouter: (router, params) ->
    url = utils.reverse router, params
    for item in @items
      if item.route == router.name
        return item
      if @isActive(item, url)
        return item

  updateState: (name) ->
    return if @disposed
    for subview in @subviews
      subview.updateState(arguments...)
    if arguments.length == 4
      [controller, params, router, opts] = arguments
      item = @getActiveForRouter(router, params)
    else
      item = name and @getItem(name) or @getActiveItem()
    if not item
      @$el.children().removeClass('active')
      return
    node = @getItemNode(item.name)
    if node.find('.nav').length
      # has subnav, only need to set subnav active
      return
    node.addClass('active').siblings().removeClass('active')
    return

  getItemNode: (name) ->
    name = name.name or name
    return @$el.find("[data-name='#{name}']")

  render: ->
    super
    @items.forEach (item) =>
      if item.subnav
        # render subnav
        subnav = new MenuView
          items: item.subnav
          container: @getItemNode(item)
        @subview "submenu-#{item.name}", subnav

  initFoldable: ->
    setTimeout =>
      # give a render break for element height
      for k, v of @subviewsByName
        v.$el.data('name', k).foldable toggler: v.$el.prev()

  listen:
    'addedToDOM': 'initFoldable'
