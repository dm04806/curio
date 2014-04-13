Model = require 'models/base/model'

stringify = (s) ->
  if Array.isArray(s)
    s = s.map (item) ->
      item.text or item
    s = s.join(', ')
  if 'string' != typeof s
    s = JSON.stringify(s)
  return s

keywords2pattern = (words) ->
  words.map (item) ->
    text: item,
    blur: true



# Reply-rule
module.exports = class Rule extends Model

  kind: 'rrule'

  defaults:
    type: 'keyword'
    replyType: 'text'

  is: (type) ->
    @get('type') == type

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

    if not rule.type
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
    # always use a new Array, to trigger the 'change' event
    p = @attributes.pattern.slice()
    # the single element must use new Object, too
    p[index] = _.assign {}, p[index], data
    @set 'pattern', p

  removeKeyword: (index) ->
    console.log index
    p = @attributes.pattern.slice()
    p.splice(index, 1)
    @set 'pattern', p

  save: ->
    @responder.save()

  destroy: ->
    resp = @responder
    coll = @collection
    coll.remove this
    resp.save()
      .error =>
        # add it back if save failed.
        coll.add this

  ptitle: ->
    if @is('keyword')
      __("rule.ptitle", @index + 1, @get('name'))
    else
      __("rule.#{@get 'name'}.title")

  serialize: ->
    _.clone(@attributes)
