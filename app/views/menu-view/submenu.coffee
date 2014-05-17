mediator = require 'mediator'
View = require 'views/base/view'
SubmenuButtonView = require './submenu_button'

MenuBase = require './menu_base'


module.exports = class Submenu extends View
  _.extend @prototype, MenuBase

  BUTTON_LIMIT: 5
  autoRender: true
  noWrap: true
  template: require './templates/submenu'

  listSelector: '.wx-submenu'

  events:
    # 阻止冒泡，因为子菜单为主菜单的 childNode
    # 而点击主菜单项已有其他事件
    'click': (e) -> e.stopPropagation()

  initialize: (options) ->
    if not options.parent
      throw new Error('pass a MainButtonView as `options.parent`')
    @parent = options.parent
    super
    @parent.on 'dispose', => @dispose()
    @container = @parent.$el

  render: ->
    super
    MenuBase._initialize.call(this)

  # 添加一个子菜单项
  getButtonView: (data) ->
    new SubmenuButtonView
      data: data
      container: @$list
      containerMethod: 'prepend'

  # Place the Submenu in center
  repose: ->
    width = @parent.$el.width()
    self_width = @$el.width()
    @$el.css 'left', width/2 - self_width/2
    @parent

  close: ->
    @$el.hide()
    @repose()
    for v in @buttons
      v.deactivate()

  open: ->
    @$el.show()
    @repose()

  toggle: ->
    if @$el.is(':visible')
      @close()
    else
      @open()

  renderButtons: ->
    items = @parent.data.sub_button
    items?.forEach (item) => @addButtonView(item)

  listen:
    'addedToDOM': 'renderButtons'
