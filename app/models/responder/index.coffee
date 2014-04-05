Model = require 'models/base/model'
Collection = require 'models/base/collection'
mediator = require 'mediator'

Rule = require './rule'

TYPE_FILTERS =
  text: (rule) ->
    # rule.pattern is String means to match text messages
    'string' == typeof rule.pattern
  subscribe: (rule) ->
    rule.pattern.type == 'event' and rule.pattern.event == 'subscribe'
  any: (rule) ->
    rule.pattern == '*'


# Reply-rule
module.exports = class Responder extends Model
  kind: 'responder'

  getRules: ->
    filter = @filter
    rules = @get('rules')
    if filter
      rules = rules.filter(filter)
    new Collection rules, model: Rule

  setFilter: (filter) ->
    @set 'filter', filter
    @filter = TYPE_FILTERS[filter]
