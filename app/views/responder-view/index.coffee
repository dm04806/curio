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
    @$list = @$el.find('#rules')
    # register tab view
    @subview 'tabs', new Menu
      container: @$el.find('.tabs-filter')
      items: navTabs
    @subview('tabs').updateState @data.tabname

    # render rules list
    collection = @collection = @model.getRules()
    counter = 0
    collection.each (rule, index) =>
      return if rule.invisible
      rule.index = counter
      counter += 1
      @push rule

  newRule: ->
    rule = @model.newRule()
    rule.index = -1
    @collection.add rule, {at: 0}
    view = @push rule, 'prepend'
    view.unfold()

  push: (rule, method='append') ->
    view = new RuleView
      model: rule
      container: @$list
      containerMethod: method
    @subview "rule-#{rule.cid}", view

  context: ->
    filter: @model.filter
