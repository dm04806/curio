EditFormView = require 'views/common/edit_form'
MarkerView = require 'views/widgets/map_marker'
Place = require 'models/place'
mediator = require 'mediator'

module.exports = class ChannelView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

  render: ->
    super
    @subview 'marker', new MarkerView el: @$el.find('.map')
