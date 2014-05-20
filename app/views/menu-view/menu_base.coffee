
module.exports =
  BUTTON_LIMIT: 3

  _initialize: ->
    @buttons = []
    # section for edit menu item property
    @$btn_add = @$('[data-op=toAddButton]')
    @$list = @$(@listSelector)
    @$list.sortable()

  #添加一个菜单项
  addButtonView: (data, options) ->
    return if @buttons.length >= @BUTTON_LIMIT
    view = @getButtonView data, options
    view_name = "button-#{view.cid}"
    @subview view_name, view
    @buttons.push view
    view.on 'delete', => @removeButton view
    view.on 'activate', => @deactivateOthers view
    # hide add button if reach maxinum limit
    @disableAdd() if @buttons.length >= @BUTTON_LIMIT
    @trigger 'button-add'

  # Dump all button data
  dump: ->
    @buttons.map (view) ->
      if view.hasSubmenu()
        {
          name: view.getBtnText()
          sub_button: view.submenu.dump()
        }
      else
        view.getVals()

  removeButton: (view) ->
    _.pull @buttons, view
    @removeSubview view
    @enableAdd()
    @trigger 'button-remove'

  removeAllButtons: ->
    for view in @buttons
      @removeSubview view
    @buttons = []
    @enableAdd()
    @trigger 'button-remove'

  deactivateOthers: (activeOne) ->
    for view in @buttons
      if view isnt activeOne
        view.deactivate()

  disableAdd: ->
    @$btn_add.attr('disabled', true)

  enableAdd: ->
    @$btn_add.removeAttr('disabled')

  toAddButton: (node) ->
    @addButtonView()
