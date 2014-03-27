# Application-specific utilities
# ------------------------------
mediator = require 'mediator'
{SITE_ROOT,API_ROOT} = require 'consts'

$.ajaxSetup
  dataType: 'json',
  beforeSend: (xhr) ->
    url = @url or ''
    if url.indexOf(API_ROOT) == 0
      @xhrFields =
        withCredentials: true
    if @type in ['POST', 'PUT', 'DELETE']
      xhr.setRequestHeader('x-csrf-token', $.cookie('csrf'))

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


delayed = (fn, delay) ->
  t = 0
  delay = delay or 120
  ->
    clearTimeout t
    t = setTimeout fn, delay

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
  delayed: delayed
  makeurl: makeurl
  store: store

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
