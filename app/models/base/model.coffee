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

  urlKey: 'id'

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
    "#{root}/#{@get @urlKey}"

  parse: (res, options) ->
    ret = res
    for field in ['created_at', 'updated_at']
      if ret.hasOwnProperty(field)
        ret[field] = new Date(ret[field])
    return ret

  loaders: {}
  # loaders use a raw ajax request, relation use Backbone.sync to load data,
  relations: {}

  # return a jqXHR promise
  load: (what, args..., callback) ->
    config = @loaders[what]
    if 'function' == typeof config
      return config.call(this, args..., callback)
    if not config and @relations[what]
      config = @related(what, args...).fetch()
    if not config
      # load from url
      config =
        url: "/#{what}"
        params: args[0]
      utils.debug "don't know how to load '#{what}', try conventional url"

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
      res = config.parse?.call(this, res) or res
      callback? null, res
    .error (xhr, error) =>
      callback? error

  # always return a Model / Collection
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


