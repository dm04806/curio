mediator = require 'mediator'
View = require 'views/base/view'



module.exports = class AutoreplyRuleView extends View
  autoRender: true
  getTemplateFunction: ->
    try
      require "./templates/rule/#{@model.get 'type'}"
    catch
      require "./templates/rule/default"
  noWrap: true
  render: ->
    super
    @$el.find('.foldable').foldable()
    setTimeout =>
      @switchReplyType()

  switchReplyType: () ->
    tab = @$el.find(".reply-types a[data-type=#{@model.get 'replyType'}]")
    tab.tab('show')

  listen:
    'model:replyType change': 'switchReplyType'
