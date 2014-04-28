{API_ROOT} = require 'consts'
utils = require 'lib/utils'
Collection = require './collection'

plular = (name) ->
  name + 's'

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
    if not config
      obj = @related(what, args...)
      if obj
        promise = obj.fetch()
        promise.done (res) ->
          callback? null, obj
        .error (xhr, err) ->
          callback? err
        return promise

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
  # Usage
  #
  #   Model.prototype.relations = {
  #     hasMany: {
  #       model2: Model2
  #     },
  #     hasOne: {
  #       model3: Model3
  #     }
  #   }
  #
  #   model.related('model2')
  #
  # @return {Model|Collection}
  #
  related: (what, args...) ->
    hasMany = what of @relations.hasMany
    cls = @relations.hasMany[what] or @relations.hasOne[what]

    if not cls
      utils.debug("No relation about '#{what}' for #{@kind}")
      return

    params = args[0] || {}

    if hasMany
      collection = null
      if cls.__super__?.constructor is Collection
        # construct from a Collection
        collection = new cls [], params: params
        collection.urlRoot = "#{@url()}/#{plular(cls::model::kind)}"
      else if cls.__super__?.constructor is Model
        # construct from cls.collection
        collection = cls.collection params: params
        collection.urlRoot = "#{@url()}/#{plular(cls::kind)}"
      else
        # cls is a pure function
        return cls.call(this, args...)

      # sign:
      #   users.media = media
      collection[@kind] = this
      collection
    else
      model = new cls
      model.set "#{@kind}_id", @id
      model


