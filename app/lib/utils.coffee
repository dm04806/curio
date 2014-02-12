# Application-specific utilities
# ------------------------------
mediator = require 'mediator'
{SITE_ROOT,API_ROOT} = require 'consts'

$.fn.anim = (cls) ->
  @removeClass("animated #{this[0]._last_anim or ''}")
  this[0]._last_anim = cls
  setTimeout =>
    @addClass("animated #{cls}")

$.ajaxSetup
  dataType: 'json',
  beforeSend: (xhr) ->
    url = @url or ''
    if url.indexOf(API_ROOT) == 0
      @xhrFields =
        withCredentials: true
    if @type in ['POST', 'PUT', 'DELETE']
      xhr.setRequestHeader('x-csrf-token', $.cookie('csrf'))


# Override library functions
redirectTo = Chaplin.utils.redirectTo
Chaplin.utils.redirectTo = (params) ->
  url = params?.url
  if url
    # clean url for chaplin
    if ~url.indexOf(SITE_ROOT)
      url = url.replace SITE_ROOT, ''
    if url[0] is '/'
      url = url.replace '/', ''
    params.url = url
  redirectTo.apply Chaplin.utils, arguments

sync = Backbone.sync
Backbone.sync = (args...) ->
  resolved = false
  setTimeout ->
    if not resolved
      $('body').addClass('syncing')
  , 300
  _sync = =>
    sync.apply(this, args).always ->
      resolved = true
      $('body').removeClass('syncing')
  return _sync() unless mediator.site_error
  # if site error found, do fetch when error resolved
  promise = $.Deferred()
  # fake delay for loading spinner debug
  #setTimeout =>
  mediator.site_error.on 'resolve', =>
    _sync()
    .done ->
      promise.resolve arguments...
    .error ->
      promise.reject arguments...
  #, 1000
  return promise


# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

store = (item, value) ->
  if value isnt undefined
    return localStorage.setItem(item, JSON.stringify(value))
  try
    value = JSON.parse(localStorage.getItem(item))
  catch error
    utils.debug '[curio store]:', item, error
    localStorage.setItem(item, '')
  return value


makeurl = (url, params) ->
  payload = utils.queryParams.stringify params
  if payload
    sep = if url.indexOf('?') >= 0 then '&' else '?'
    url = url + sep + payload
  url

_.assign utils,
  # collect client side error
  error: console.error.bind(console)
  debug: console.debug.bind(console)
  makeurl: makeurl
  store: store

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
