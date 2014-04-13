mediator = require 'mediator'
Rule = require 'models/responder/rule'
MainView = require 'views/common/main'
Menu = require 'views/widgets/menu'
RuleView = require './rule'

navTabs = [
  name: 'autoreply.keyword'
  url: '/autoreply?tab=keyword'
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
    filter = @model.filter
    @data.tabname = "autoreply.#{filter}"
    super # render the DOM
    # register tab view
    @subview 'tabs', new Menu
      container: @$el.find('.tabs-filter')
      items: navTabs
    @subview('tabs').updateState @data.tabname

    # render rules list
    listNode = @$el.find('#rules')
    collection = @model.getRules()
    counter = 0
    collection.each (rule, index) =>
      return if rule.invisible
      rule.index = counter
      counter += 1
      row = new RuleView
        model: rule
        container: listNode
      @subview "rule-#{rule.cid}", row

  context: ->
    filter: @model.filter
