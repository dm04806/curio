{API_ROOT} = require 'consts'
utils = require 'lib/utils'

# Base model.
module.exports = class Model extends Chaplin.Model
  @all: (params) ->
    Collection = require './collection'
    new Collection [], {model: this, params: params}

  _(@prototype).extend Chaplin.SyncMachine

  initialize: ->
    super
    @on 'request', @beginSync
    @on 'sync', @finishSync
    @on 'error', @unsync

  apiRoot: API_ROOT

  urlKey: 'id'

  urlPath: ''

  urlRoot: ->
    urlPath = @urlPath
    if 'function' is typeof urlPath
      urlPath = @urlPath()
    if urlPath
      @apiRoot + urlPath
    else if @collection
      @collection.url()
    else
      throw new Error('Model must redefine urlPath')
