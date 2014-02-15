{API_ROOT} = require 'consts'
utils = require 'lib/utils'

Collection = require './collection'

# Base model.
module.exports = class Model extends Chaplin.Model
  _.extend @prototype, Chaplin.SyncMachine

  @all: (params) ->
    new Collection [], {model: this, params: params}

  @collection: (items, opts={}) ->
    opts.model = this
    new Collection items, opts

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
    if not urlPath and @kind
      urlPath = "/#{@kind}s"
    if urlPath
      @apiRoot + urlPath
    else if @collection
      @collection.url()
    else
      throw new Error('Model must redefine urlPath')

  url: ->
    root = @urlRoot()
    "#{root}/#{@get @urlKey}"

  parse: (res, options) ->
    ret = res.item
    for field in ['created_at', 'updated_at']
      if ret.hasOwnProperty(field)
        ret[field] = new Date(ret[field])
    return ret

  loaders: {}
  relations: {}

  load: (what, args..., callback) ->
    config = @loaders[what]
    if not config and @relations[what]
      config = ->
        @related(what, args...).fetch()
    if not config
      throw new Error "don't know how to load '#{what}'"

    if 'function' == typeof config
      return config.call(this, args..., callback)

    # default arguments
    callback = callback or ->
    url = config.url
    if 'string' is typeof url
      url = (=> @url() + config.url)

    $.ajax
      type: config.method or 'get',
      data: config.params,
      url: url.call(this)
    .done (res) =>
      callback null, config.parse.call(this, res)
    .error (xhr, error) =>
      callback error

  related: (what, args...) ->
    @relations[what].call(this, args...)


