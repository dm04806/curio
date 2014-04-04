mediator = require 'mediator'
MainView = require 'views/common/main'
RuleRow = require './row'
Rule = require 'models/responder/rule'

module.exports = class AutoreplyIndex extends MainView
  template: require './templates/index'
  render: ->
    super
    listNode = @$el.find('#rules')
    _.each @model.get('rules'), (rule, i) =>
      model = new Rule(rule)
      model.set 'index', i + 1
      row = new RuleRow
        model: model
        container: listNode
      @subview "rule-#{i}", row

