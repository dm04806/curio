Model = require './model'
{API_ROOT} = require 'consts'
utils = require 'lib/utils'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  _(@prototype).extend Chaplin.SyncMachine

  # Use the project base model per default, not Chaplin.Model
  model: Model

  initialize: (models, options) ->
    super
    @on 'request', @beginSync
    @on 'sync', @finishSync
    @on 'error', @unsync
    if not @urlRoot and options?.model
      @urlRoot = options.model::urlRoot()
    if options?.params
      @params = options.params

  urlRoot: ''

  url: ->
    url = @urlRoot
    return utils.makeurl(url, @params)

  parse: (res, options) ->
    @total = res.total
    return res.items
