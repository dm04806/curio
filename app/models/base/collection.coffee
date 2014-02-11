{API_ROOT} = require 'consts'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  _.extend @prototype, Chaplin.SyncMachine

  initialize: (models, options) ->
    super
    @on 'request', @beginSync
    @on 'sync', @finishSync
    @on 'error', @unsync
    if not @urlRoot and @model
      @urlRoot = @model::urlRoot()
    if options?.params
      @params = options.params

  urlRoot: ''

  url: ->
    url = @urlRoot
    return utils.makeurl(url, @params)

  parse: (res, options) ->
    @total = res.total
    return res.items.map (item) ->
      { item: item }
