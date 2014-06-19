FormModalView = require 'views/common/form_modal'
Channel = require 'models/channel'
mediator = require 'mediator'

module.exports = class CreateChannel extends FormModalView
  template: require './templates/create'

  context: ->
    media = mediator.media
    form_action: Channel.urlRoot()

  addRow: (node) ->
    prev = node.closest('tr').prev()
    new_id = Number(prev.find('input[name=scene_id]').val())
    console.log prev, new_id
    new_id = new_id + 1 or ''
    clone = prev.clone()
    clone.find('input').val('')
    clone.find('input[name=scene_id]').val(new_id)
    clone.insertAfter(prev)

  _send: (e) ->
    form = e.target
    data = $(form).serialize()
    items = []
    media_id = mediator.media.id
    $(form).find('tr').each (i, elem) ->
      name = $(elem).find('input[name=name]').val()
      scene_id = $(elem).find('input[name=scene_id]').val()
      if scene_id
        items.push(
          name: name or "Scene #{scene_id}"
          scene_id: scene_id
          media_id: media_id
        )
    return if not items.length
    $.send(e.target.action, items)
