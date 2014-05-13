mediator = require 'mediator'
Place = require 'models/place'

EditFormView = require 'views/common/edit_form'
MarkerView = require './map_marker'


module.exports = class ChannelView extends EditFormView
  template: require './templates/show'

  context: ->
    isNew: @model.isNew()

  render: ->
    super

    marker = @subview 'marker', new MarkerView
      container: @$el.find('#place-marker')
      model: @model
    # display big map for new creating place
    if @model.isNew()
      @toBigMap()
    marker.on 'searched', @updateByPOI.bind(this)

  toBigMap: ->
    @subview('marker').enlarge()

  updateByPOI: (poi) ->
    console.log poi
    @model.set
      address: "#{poi.city} #{poi.address}"
      phone: poi.tel
      name: poi.name

  updateInput: (model) ->
    for k, v of model.changed
      input = @$el.find("input[name='#{k}']")
      continue if not input[0] or input.val() == v
      input.blur().val(v)

  listen:
    'change model': 'updateInput'
