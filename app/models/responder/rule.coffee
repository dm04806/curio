Model = require 'models/base/model'

stringify = (s) ->
  if Array.isArray(s)
    s = s.map (item) ->
      (item.text or item.value or item).btrunc(5)
    s = s.slice(0,3).join(', ')
  if 'string' != typeof s
    s = (s.value or JSON.stringify(s)).btrunc(15)
  return s

keywords2pattern = (words) ->
  words.map (item) ->
    if 'string' == typeof item
      text: item
      blur: true
    else
      item



# Reply-rule
module.exports = class Rule extends Model

  kind: 'rrule'

  is: (type) ->
    @get('type') == type

  initialize: ->
    super
    @validate()
    @on 'change:pattern', (model, data) ->
      @set 'name', stringify(data)

  ##
  # normalize attrs for render and edit
  #
  validate: (attrs) ->
    rule = attrs or @attributes
    pattern = rule.pattern or ''

    # sync name with pattern
    rule.name = stringify(pattern)

    # determine reply type based on handler
    rule.replyType = rule.handler.type or 'text'

    if not rule.type
      # set type by pattern
      if 'string' is typeof pattern and pattern[0] == '$'
        rule.type = pattern.replace('$', '')
      else if 'object' is typeof pattern
        rule.type = 'advanced'
      else
        rule.type = 'keyword'

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
