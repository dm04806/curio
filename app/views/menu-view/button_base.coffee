mediator = require 'mediator'
View = require 'views/base/view'
{ENTER,ESC} = require 'lib/keyboard'
{delayed} = require 'lib/utils'

common = require 'views/common/utils'

ButtonPropsView = require './button_props'


module.exports = class MenuButtonView extends View
  autoRender: true
  className: 'wx-menu-button'
  tagName: 'li'
  template: require './templates/button'

  render: ->
    super
    @$input = @$('input[name=name]')
    setTimeout => @toEdit() if not @data.name
    # bind data to the DOM
    @$el.data(@data)

  hasSubmenu: ->
    @submenu?.buttons.length > 0

  getBtnText: ->
    $.trim(@$input.val())

  getVals: ->
    data = @$el.data()
    return {
      name: data.name
      type: data.type
      value: data.value
    }

  update: (data, options) ->
    @$el.data(data)
    for k, v of data
      node = @$("> [data-ref=\"#{k}\"]").val(v)
      node.text(v) if v
    if not options?.silent
      @trigger 'update', data
      @subview('props')?.load()

  editDone: ->
    @_updateText()
    @$el.removeClass('editting')

  toEdit: ->
    @activate()
    @$el.addClass('editting')
    @$input.focus()

  toDelete: ->
    @trigger 'delete'
    #common.confirm 'menu.main.delete.confirm', =>

  showPropsView: ->
    view = new ButtonPropsView button: this
    @subview 'props', view

  disposePropsView: ->
    @removeSubview('props')

  activate: ->
    @showPropsView()
    return if @_active
    @_active = true
    @trigger 'activate'
    @$el.addClass 'active'

  deactivate: ->
    return if not @_active
    @_active = false
    @trigger 'deactivate'
    @$el.removeClass 'active'
    @disposePropsView()

  _updateText: () ->
    text = @getBtnText()
    $text = @$('> span.text').text(text or __('menu.click_to_input'))
    if not text
      $text.addClass('placeholder')
    else
      $text.removeClass('placeholder')
    if text.blength() > 16
      common.notify 'menu.text_overflow'
    else
      @update 'name': text

  updateText: delayed(@::_updateText, 200)

  onKeyDown: (e) ->
    if e.which == ENTER or e.which == ESC
      @editDone()

  onClick: ->
    if not @getBtnText()
      @toEdit()
    else
      @activate()

  reloadSortable: ->
    @$el.parent().sortable('reload')

  listen:
    'addedToDOM': 'reloadSortable'
    'dispose': 'reloadSortable'

  events:
    'click': 'onClick'
    'dblclick': (e) ->
      e.preventDefault()
      e.stopPropagation()
      @toEdit()
    'input >input': 'updateText'
    'change >input': 'updateText'
    'blur >input': 'editDone'
    'keydown >input': 'onKeyDown'
