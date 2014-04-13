{API_ROOT} = require 'consts'
utils = require 'lib/utils'

# Base model.
module.exports = class Model extends Chaplin.Model
  _.extend @prototype, Chaplin.SyncMachine

  @collection: (items, opts) ->
    Collection = require './collection'
    if !Array.isArray(items)
      opts = items
      items = []
    opts = opts or {}
    opts.model = this
    new Collection items, opts

  initialize: ->
    super
    @on 'request', @beginSync
    @on 'sync', @finishSync
    @on 'error', @unsync

  apiRoot: API_ROOT

  urlPath: ''

  urlRoot: ->
    urlPath = _.result this, 'urlPath'
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
    return root if @isNew()
    "#{root}/#{@get @idAttribute}"

  parse: (res, options) ->
    ret = res
    for field in ['created_at', 'updated_at']
      if ret.hasOwnProperty(field)
        ret[field] = new Date(ret[field])
    return ret

  # loaders use a raw ajax request, and returns a jqXHR promise
  # relation directly returns a Backbone.Model or Collection,
  # you must call `model.fetch()` manully to start load from remote
  loaders: {}
  relations: {}

  ##
  # Load from sub-directory of current model's url
  #
  # Example:
  #
  #   model.load('/url')
  #     -> $.get('/model/:id/url')
  #
  #   model.load('model2')
  #     -> model.related('model2').fetch()
  #
  # @param {string} what, name of the loader
  # @return {jqXHR} promise
  #
  load: (what, args..., callback) ->
    config = @loaders[what]

    # A direct function
    if 'function' == typeof config
      return config.call(this, args..., callback)

    # not configured in loaders, fetch from relation
    if not config and @relations[what]
      return @related(what, args...).fetch()

    if not config
      # load from url
      config =
        url: "/#{what}"
      utils.debug "don't know how to load '#{what}', try conventional url"

    # handle default arguments
    callback = callback or ->
    params = _.extend({}, args[0], config.params)
    url = config.url
    if 'string' is typeof url
      url = (=> @url() + config.url)

    $.ajax
      type: config.method or 'get',
      data: params,
      url: url.call(this)
    .done (res) =>
      res = config.parse?.call(this, res, params) or res
      callback? null, res
    .error (xhr, error) =>
      callback? error

  ##
  #
  # @return {Model|Collection}
  #
  related: (what, args...) ->
    model = @relations[what]
    if not model
      throw new Error("No relation about '#{what}' for #{@kind}")
    if model.__super__?.constructor is Model
      opts = args[0] || {}
      #opts["#{@kind}_id"] = @id
      collection = model.collection params: opts
      collection.urlRoot = "#{@url()}/#{model::kind}s"
      return collection
    model.call(this, args...)


