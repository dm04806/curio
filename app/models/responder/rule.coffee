Model = require 'models/base/model'

stringify = (s) ->
  if 'string' != typeof s
    s = JSON.stringify(s)
  return s

# Reply-rule
module.exports = class Rrule extends Model
  kind: 'rrule'

  defaults:
    type: 'keyword'
    replyType: 'text'
    name: ''
    pattern: ''
    handler: ''

  initialize: ->
    super
    @normalize()

  normalize: ->
    # normalize attrs for render and edit
    rule = @attributes
    # default name to pattern
    pattern = rule.pattern or ''
    rule.name = rule.name or stringify(pattern)
    rule.replyType = rule.handler.type or 'text'
    # set type by pattern
    if 'string' is typeof pattern and pattern[0] == '$'
      rule.type = pattern.replace('$', '')
    if 'object' is typeof pattern
      rule.type = 'advanced'
    # pattern must be an Array
    if pattern and not Array.isArray(pattern)
      rule.pattern = [{ text: rule.pattern, blur: true }]

  set: ->
    super
    @normalize

