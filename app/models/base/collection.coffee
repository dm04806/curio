{API_ROOT} = require 'consts'
utils = require 'lib/utils'
mediator = require 'mediator'

LIMIT = 20

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  _.extend @prototype, Chaplin.SyncMachine

  params: {}

  model: require './model'

  PERPAGE: LIMIT

  initialize: (models, options) ->
    super
    @on 'request', @beginSync
    @on 'sync', @finishSync
    @on 'error', @unsync
    if not @urlRoot and @model
      @urlRoot = @model::urlRoot()
    if options?.params
      @params = options.params
    _.defaults @params,
      offset: 0
      limit: @PERPAGE

  urlRoot: ''

  url: (params) ->
    params = _.extend @params, params
    url = @urlRoot
    if 'function' == typeof url
      url = @urlRoot()
    return utils.makeurl(url, params)

  parse: (res, options) ->
    @total = res.total
    return res.items

  load: (what) ->
    all = @map (item) ->
      item.load(what)
    $.when(all)

