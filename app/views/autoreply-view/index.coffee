mediator = require 'mediator'
Rule = require 'models/responder/rule'
MainView = require 'views/common/main'
Menu = require 'views/widgets/menu'
RuleRow = require './row'

navTabs = [
  name: 'autoreply.text'
  url: '/autoreply?tab=text'
,
  name: 'autoreply.subscribe'
  url: '/autoreply?tab=subscribe'
,
  name: 'autoreply.any'
  url: '/autoreply?tab=any'
]


module.exports = class AutoreplyIndex extends MainView
  template: require './templates/index'

  render: ->
    super

    # register tab view
    @subview 'tabs', new Menu
      container: @$el.find('.tabs-filter')
      items: navTabs

    @subview('tabs').updateState(@model.get 'filter')

    listNode = @$el.find('#rules')
    @model.getRules().each (rule, i) =>
      rule.set 'index', i + 1
      row = new RuleRow
        model: rule
        container: listNode
      @subview "rule-#{i}", row
    newRow = new RuleRow
      model: new Rule
        pattern: ''
        handler: ''
      container: listNode
    @subview "rule-new", newRow
