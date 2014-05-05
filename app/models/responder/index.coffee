Model = require 'models/base/model'
Collection = require 'models/base/collection'
mediator = require 'mediator'

Rule = require './rule'


# Reply-rule
module.exports = class Responder extends Model
  kind: 'responder'

  url: ->
    "#{@apiRoot}/medias/#{@get 'media_id'}/responder"

  idAttribute: 'media_id'

  initialize: ->
    # create a collection containing all the rules
    @rules = new Collection [], model: Rule
    @rules.comparator = 'index' # always sort collection based on 'index'
    @on 'change:rules', (options) ->
      # set rules of collection
      @rules.reset( @get 'rules' )
      @rules.each (rule, i) =>
        # reset index based on Array order
        rule.set 'index', i
        rule.responder = this
    @rules.on 'change remove add', => @syncRules()


  syncRules: ->
    # silently set rules, don't trigger event
    @set 'rules', @rules.toJSON(), { silent: true }

  getRules: ->
    @rules
    #coll = new Collection [], model: Rule
    #rules = coll.source = @rules
    #coll

  newRule: (type) ->
    type = type or @filter or 'keyword'
    rule = Rule.create(type)
    rule.responder = this
    rule

  canMulti: (type) ->
    # only keyword type rule can have multiple
    type == 'keyword'

  setFilter: (type) ->
    @filter = type
    if not @rules.some((rule) -> rule.is(type))
      @rules.add @newRule(type)
