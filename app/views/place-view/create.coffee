EditFormView = require 'views/common/edit_form'
Place = require 'models/place'
mediator = require 'mediator'

module.exports = class CreatePlace extends EditFormView
  template: require './templates/create'

  context: ->
    media = mediator.media
    form_action: "#{media.url()}/places"
