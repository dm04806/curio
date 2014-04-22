FormModalView = require 'views/common/form_modal'
Channel = require 'models/channel'
mediator = require 'mediator'

module.exports = class CreateChannel extends FormModalView
  template: require './templates/create'

  context: ->
    media = mediator.media
    form_action: "#{media.url()}/channels"

  addRow: (node) ->
    prev = node.closest('tr').prev()
    clone = prev.clone()
    clone.insertAfter(prev)

