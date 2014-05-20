mediator = require 'mediator'
Place = require 'models/place'

EditFormView = require 'views/common/edit_form'
MarkerView = require './map_marker'


module.exports = class ChannelView extends EditFormView
  template: require './templates/show'

  context: ->
    isNew: @isNew
    fromCreate: @data.from == 'create'

  initialize: ->
    super
    @isNew = @model.isNew()

  render: ->
    super
    marker = @subview 'marker', new MarkerView
      container: @$el.find('#place-marker')
      model: @model
    marker.on 'searched', @updateByPOI.bind(this)
    marker.initAutocomplete @$el.find("input[name=address]")

  toBigMap: ->
    @subview('marker').enlarge()

  updateByPOI: (poi) ->
    @model.set
      address: "#{poi.city} #{poi.address}"
      phone: poi.tel?.split(';').join(', ')
      name: poi.name
      lat: poi.location.lat
      lng: poi.location.lng

  updateInput: (model) ->
    for k, v of model.changed
      input = @$el.find("input[name='#{k}']")
      continue if not input[0] or input.val() == v
      input.blur().val(v)

  _submitDone: (res) ->
    # do nothing when create, cause will notify user in the next page
    super if not @isNew

  listen:
    'change model': 'updateInput'
