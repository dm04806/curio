mediator = require 'mediator'
View = require 'views/base/view'
TabsView = require 'views/widgets/tabs'


replyTabItems = [
  name: 'text'
,
  name: 'news'
,
  name: 'image'
]


module.exports = class AutoreplyRuleView extends View
  autoRender: true
  template: require "./templates/rule"
  noWrap: true
  context: ->
    type = @model.get 'type'
    body: require "./templates/rule/#{type}"
  render: ->
    super
    replyTabs = new TabsView
      items: replyTabItems
      container: @$el
    @subview 'reply-tabs', replyTabs
    # bind tabs
