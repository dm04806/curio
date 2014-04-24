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
    clone.find('input').val('')
    clone.insertAfter(prev)

  _send: (e) ->
    form = e.target
    data = $(form).serialize()
    items = []
    media_id = mediator.media.id
    $(form).find('input[name=name]').each (i, elem) ->
      val = $.trim(elem.value)
      if val
        items.push({ name: val, media_id: media_id })
    return if not items.length
    $.send(e.target.action, items)

  listen:
    # 表单提交成功后刷新页面
    'submitted': -> location.reload()
