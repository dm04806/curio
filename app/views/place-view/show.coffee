mediator = require 'mediator'
Place = require 'models/place'
ChooseChannel = require './choose_channel'
ChannelListView = require './channel_list'

EditFormView = require 'views/common/edit_form'
MarkerView = require './map_marker'

Selector = require 'views/widgets/loc_selector'



module.exports = class ChannelView extends EditFormView
  template: require './templates/show'

  context: ->
    isNew: @isNew
    isSuper: mediator.user.isSuper
    fromCreate: @data.from == 'create'

  initialize: ->
    super
    @isNew = @model.isNew()

  render: ->
    super
    @subview 'selector', new Selector
      el: @$('.loc-selector')
      data:
        current: @model.get 'loc_id'

    marker = @subview 'marker', new MarkerView
      container: @$('#place-marker')
      model: @model
    marker.on 'enlarge', =>
      @$('div[for=address] .col-sm-7').attr('class', 'col-sm-11')
      @$('div[for=address] .col-sm-3').hide()
    marker.on 'shrink', =>
      @$('div[for=address] .col-sm-11').attr('class', 'col-sm-7')
      @$('div[for=address] .col-sm-3').show()
    marker.initAutocomplete @$el.find("input[name=address]")

    @subview 'channels', new ChannelListView
      container: @$('.place-channels')
      model: @model
    #@chooseChannel()

  toBigMap: ->
    @subview('marker').enlarge()

  chooseChannel: (node) ->
    view = new ChooseChannel model: @model
    view.on 'confirm', =>
      channels = view.getChannels()
      @model.set 'channels', channels
      @subview('channels').renderItems()
      ## automatical save changes
      @model.save() if not @model.isNew()
      view.close()

  updateInput: (model) ->
    for k, v of model.changed
      input = @$el.find("input[name='#{k}']")
      continue if not input[0] or input.val() == v
      input.val(v)

  updateMarker: ->
    lat = $.trim(@$('input[name=lat]').val())
    lng = $.trim(@$('input[name=lng]').val())
    if lat and lng
      @subview('marker').setLatlng(lat, lng)

  _submitDone: (res) ->
    # do nothing when create, cause will notify user in the next page
    super if not @isNew

  events:
    'blur input[name=lat],input[name=lng]': 'updateMarker'

  listen:
    'change model': 'updateInput'
