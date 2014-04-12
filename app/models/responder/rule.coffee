Model = require 'models/base/model'

stringify = (s) ->
  if 'string' != typeof s
    s = JSON.stringify(s)
  return s

keywords2pattern = (words) ->
  words.map (item) ->
    text: item,
    blur: true

# Reply-rule
module.exports = class Rrule extends Model
  kind: 'rrule'

  defaults:
    type: 'keyword'
    replyType: 'text'

  initialize: ->
    super
    @validate()

  ##
  # normalize attrs for render and edit
  #
  validate: (attrs) ->
    rule = attrs or @attributes
    pattern = rule.pattern or ''

    # default name to pattern
    rule.name = rule.name or stringify(pattern)

    # determine reply type based on handler
    rule.replyType = rule.handler.type or 'text'

    # set type by pattern
    if 'string' is typeof pattern and pattern[0] == '$'
      rule.type = pattern.replace('$', '')
    if 'object' is typeof pattern
      rule.type = 'advanced'

    # pattern will always be an Array
    if pattern and not Array.isArray(pattern)
      rule.pattern = keywords2pattern [rule.pattern]

  ##
  # Add more pattern to this rule
  #
  # @param {Array} keywords, like `['foo', 'bar']`
  #
  pushKeywords: (keywords) ->
    @pushPatterns keywords2pattern(keywords)

  pushPatterns: (patterns) ->
    p = _.union @get('pattern'), patterns
    @set 'pattern', p

  updateKeyword: (index, data) ->
    _.assign @attributes.pattern[index], data

