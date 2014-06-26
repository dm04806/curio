View = require 'views/base/view'
common = require 'views/common/utils'

# Select rule reply
module.exports = class ReplyView extends View
  autoRender: true

  template: require './templates/rule/mod/reply'

  render: ->
    super
    @switchReplyTab()

  switchReplyTab: () ->
    tab = @$el.find(".reply-types a[data-type=#{@model.get 'replyType'}]")
    return if not tab.length
    target = @$el.find(tab.attr('href'))
    tab.tab('show')
    tab.data('bs.tab').activate(target, target.parent())

  chooseNews: (node) ->
    common.alert 'comming soon'

  chooseImage: (node) ->
    common.alert 'comming soon'

  # Sync reply content
  syncReply: () ->
    pane = @$el.find('.tab-pane.active')
    type = pane.data('type')
    if type == 'text'
      @model.set 'handler', pane.find('textarea').val()

