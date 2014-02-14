# Application-specific utilities
# ------------------------------
mediator = require 'mediator'
{SITE_ROOT,API_ROOT} = require 'consts'


ANIMATION_END = "webkitAnimationEnd mozAnimationEnd
 MSAnimationEnd oanimationend
 animationend"

$.fn.anim = (cls, options, nextDelay) ->
  @removeClass("animated #{@data('_last_anim')}")
  @data '_last_anim', cls
  if 'number' is typeof options
    options = { duration: "#{options/1000}s" }
  if options?
    css = {}
    for k of options
      css["animation-#{k}"] = options[k]
    @css css
  @queue 'fx', (next) =>
    setTimeout =>
      @addClass("animated #{cls}")
    if nextDelay
      setTimeout next, nextDelay
    else
      this.one ANIMATION_END, next
  return this

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

ajax = Backbone.ajax
Backbone.ajax = (opts, args...) ->
  resolved = false
  setTimeout ->
    # show global syncing state when not GET
    # (POST, PUT, DELETE always mean user actions)
    # show loading is this takes too long
    if not resolved and not $('body').find('.loading-indicator:visible').length
      $('body').addClass('syncing')
  , 500
  _ajax = =>
    ajax.call(this, opts, args...).always ->
      resolved = true
      $('body').removeClass('syncing')
  return _ajax() unless mediator.site_error
  promise = $.Deferred()
  # if site error found, do fetch when error resolved
  mediator.site_error.on 'resolve', ->
  # fake delay for loading spinner debug
  #setTimeout ->
    _ajax()
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
    utils.debug '[storage] %s -> ', item, value
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
