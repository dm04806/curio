mediator = require 'mediator'
View = require 'views/base/view'
{delayed, isUrl} = require 'lib/utils'

module.exports = class ButtonPropsView extends View
  autoRender: true
  noWrap: true
  container: '.wx-window'
  template: require './templates/button_props'

  initialize: (options) ->
    @button = options.button
    super

  context: ->
    hasSubmenu: @button.hasSubmenu()

  render: ->
    super
    @$checkbox = @$('input[name="type"][value="view"]')
    @load()

  load: ->
    for k,v of @button.getVals()
      if k == 'type'
        # check for view url button
        @$checkbox.prop('checked', v == 'view')
        continue
      @$("[name=\"#{k}\"]").val(v)

  # Sync changed props to model
  dump: ->
    is_url = @$checkbox.prop('checked')
    text = @$('input[name=name]').val()
    data =
      type: if is_url then 'view' else 'click'
      value: @$('input[name=value]').val() or text
      name: text
    @button.update data, silent: true

  syncInput: (e) ->
    data = {}
    key = e.target.name
    val = e.target.value
    data[key] = val
    if key == 'value'
      @$checkbox.prop('checked', isUrl(val))
    @dump()

  listen:
    # always dump data back to button, when closed
    'dispose': 'dump'

  events:
    'input input': 'syncInput'
    'change input:checkbox': 'dump'
