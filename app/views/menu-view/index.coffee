mediator = require 'mediator'
common = require 'views/common/utils'

MainView = require 'views/common/main'
MenuBase = require './menu_base'

MainButtonView = require './button'


MAIN_BUTTON_LIMIT = 3


module.exports = class MenuIndexView extends MainView
  _.extend @prototype, MenuBase

  template: require './templates/index'
  listSelector: '#wx-menu-buttons'

  render: ->
    super
    @$style = @$('#wx-editor-style-inline')
    MenuBase._initialize.call(this)

  getButtonView: (data, options) ->
    new MainButtonView
      data: data
      container: @$list

  resizeButtons: ->
    total = @buttons.length
    perItemWidth = 100 / total
    @$style.html(".wx-mainmenu > li { width: #{perItemWidth}% }")
    left = MAIN_BUTTON_LIMIT - total
    @$('.wx-menu-room-left').text(left)

  resize: ->
    @resizeButtons()

  renderButtons: ->
    items = @model.get 'items'
    items.forEach (item) => @addButtonView(item)

  save: (node) ->
    node.disable()
    @model.set 'items', @dump()
    @model.save().done ->
      common.notify 'save.success'
    .error (xhr) ->
      common.xhrError xhr, 'menu_error.'
    .always ->
      node.delay(800).promise().done -> @enable()


  listen:
    'addedToDOM': 'renderButtons'
    'button-add': 'resize'
    'button-remove': 'resize'
