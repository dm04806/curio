Model = require 'models/base/model'
Collection = require 'models/base/collection'
mediator = require 'mediator'

Rule = require './rule'

TYPE_FILTERS =
  keyword: (rule) ->
    # rule.pattern is String means to match text messages
    # pattern starts with a '$' means this is a shortcode pattern,
    # should not be treated as plain keyword
    'string' == typeof rule.pattern and rule.pattern[0] != '$'
  subscribe: (rule) ->
    rule.pattern == '$subscribe'
  any: (rule) ->
    rule.pattern == '$any'

TYPE_RULES =
  keyword:
    pattern: ''
    handler: ''
  subscribe:
    index: 0
    pattern: '$subscribe'
    handler: ''
  any:
    index: Infinity
    type: 'keyword'
    pattern: '$any'
    handler: ''


# Reply-rule
module.exports = class Responder extends Model
  kind: 'responder'

  getRules: ->
    filter = @filter
    rules = @get('rules')
    if filter
      rules = rules.filter(filter)
    new Collection rules, model: Rule

  newRule: (type) ->
    _.extend {type: type}, TYPE_RULES[type]

  canMulti: (type) ->
    # only keyword type rule can have multiple
    type == 'keyword'

  setFilter: (type) ->
    @set 'filter', type
    @filter = TYPE_FILTERS[type]
