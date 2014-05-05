Model = require 'models/base/model'

stringify = (s) ->
  if Array.isArray(s)
    s = s.map (item) ->
      (item.text or item.value or item).btrunc(6)
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


RULE_DEFAULTS =
  keyword:
    pattern: ''
    handler: ''
  subscribe:
    index: 0
    pattern: '$subscribe'
    handler: ''
  any:
    index: 99999
    pattern: '$any'
    handler: '你的消息已收到，我们会尽快回复'


# Reply-rule
module.exports = class Rule extends Model
  kind: 'rrule'

  @create: (type) ->
    new Rule _.extend {type: type}, RULE_DEFAULTS[type]

  is: (type) ->
    @get('type') == type

  isNew: ->
    # the model.index is temporary for collection use
    @index < 0

  initialize: ->
    super
    @validate()
    @on 'change:pattern', (model, data) ->
      @set 'name', stringify(data)

  toJSON: ->
    attrs = @attributes
    index: attrs.index
    replyType: attrs.replyType
    name: attrs.name
    pattern: attrs.pattern
    handler: attrs.handler

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
      else if _.isPlainObject(pattern)
        rule.type = 'advanced'
      else
        rule.type = 'keyword'

    switch rule.type
      when 'keyword'
        # keyword pattern will always be an Array
        if not pattern
          rule.pattern = []
        else if not Array.isArray(pattern)
          rule.pattern = keywords2pattern [rule.pattern]
      when 'advanced'
        # pass
      else
        # make sure special rules has the corresponding pattern
        rule.pattern = "$#{rule.type}"

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

  # Save the rule, but call responder's sync method
  save: ->
    @responder.save().done =>
      @trigger 'save'

  destroy: ->
    coll = @collection
    coll.remove this
    # no need to sync with server when it's still a new rule
    return if @isNew()
    @responder.save()
      .error =>
        # add it back if save failed.
        coll.add this

  ptitle: ->
    if @is('keyword')
      if @isNew()
        __("rule.new")
      else
        __("rule.ptitle", @index + 1, @get('name'))
    else
      __("rule.#{@get 'pattern'}.title")
