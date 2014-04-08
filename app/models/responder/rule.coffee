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
    # set type by pattern
    if pattern == '$subscribe'
      rule.type = 'subscribe'
    if pattern[0] == '$any'
      rule.type = 'any'
    if 'object' is typeof pattern
      rule.type = 'advanced'
    # pattern must be an Array
    if pattern and not Array.isArray(pattern)
      rule.pattern = [{ text: rule.pattern, blur: true }]
    # handler must be an array
    if not Array.isArray(rule.handler)
      rule.handler = [rule.handler]

  set: ->
    super
    @normalize

