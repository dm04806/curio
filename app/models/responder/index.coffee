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
    index: 9999
    type: 'keyword'
    pattern: '$any'
    handler: ''


# Reply-rule
module.exports = class Responder extends Model
  kind: 'responder'

  url: ->
    "#{@apiRoot}/medias/#{@get 'media_id'}/responder"

  idAttribute: 'media_id'

  initialize: ->
    # create a collection containing all the rules
    @rules = new Collection @get('rules'), model: Rule
    @rules.on 'change', =>
      console.log @rules.serialize()
      @set 'rules', @rules.serialize()
    @rules.each (rule) =>
      rule.responder = this

  getRules: ->
    filter = @filter
    total = 0
    rules = @rules
    rules.each (rule) ->
      if filter and not rule.is(filter)
        rule.invisible = true
      else
        total += 1
        rule.invisible = false
      return
    if not total
      rules.add @newRule(filter)
    rules

  newRule: (type) ->
    type = type or 'keyword'
    _.extend {type: type}, TYPE_RULES[type]

  canMulti: (type) ->
    # only keyword type rule can have multiple
    type == 'keyword'

  setFilter: (type) ->
    @filter = type
