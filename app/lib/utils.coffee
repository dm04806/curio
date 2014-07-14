# Application-specific utilities
# ------------------------------
mediator = require 'mediator'
{CurioError,AccessError} = require 'models/errors'
{SITE_ROOT,API_ROOT} = require 'consts'

Simditor.prototype.opts.defaultImage = '/images/default.png'

$.fn.disable = ->
  @prop('disabled', true)

$.fn.enable = ->
  @prop('disabled', false)


$.ajaxSetup
  dataType: 'json',
  beforeSend: (xhr) ->
    url = @url or ''
    if url.indexOf(API_ROOT) == 0
      @xhrFields =
        withCredentials: true
    if @type in ['POST', 'PUT', 'DELETE']
      xhr.setRequestHeader('x-csrf-token', $.cookie('csrf'))

# Send json data to the server
$.send = (url, data, opts) ->
  defaults =
    type: 'POST'
    contentType: 'application/json'
    processData: false
  opts = _.defaults(opts or {}, defaults)
  # data cannot be empty string, otherwise server will report "unexpected end"
  data = JSON.stringify(data) or '{}'
  Backbone.ajax _.assign(opts, { url: url, data: data })


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

store.remove = (key) ->
  utils.debug '[storege delete] %s', key
  localStorage.removeItem(key)

delayed = (fn, delay) ->
  t = 0
  delay = delay or 120
  (args...) ->
    self = this
    clearTimeout t
    t = setTimeout (-> fn.apply(self, args)), delay

makeurl = (url, params) ->
  payload = utils.queryParams.stringify params
  if payload
    sep = if url.indexOf('?') >= 0 then '&' else '?'
    url = url + sep + payload
  url


String.prototype.blength = () ->
  this.replace(/\n\r/g, '\n').replace(/[^\x00-\xff]/g, 'xx').length

String.prototype.btrunc = (limit, ellips) ->
  btrunc(this, limit, ellips)


trunc = (text, limit) ->
  text = if text? then text else ''
  if text.length < limit
    text
  else
    text.slice(0, limit-2) + '..'

btrunc = (text, limit, ellips='..') ->
  text = if text? then text else ''
  limit = Number(limit) || 10
  if text.blength() < limit * 2
    return text
  ret = ''
  count = 0
  i = 0
  max = limit * 2 - 2
  while (count < max)
    ret += text[i]
    count += text[i].blength()
    i += 1
  ret + ellips


##
# Parse XHR error message
xhrError = (xhr) ->
  json = xhr.responseJSON or {}
  if xhr.status == 401
    # this ajax request is unauthorized
    new AccessError(json.error or 'session_timeout')
  else if xhr.status == 403
    new AccessError(json.error or 'not allowed')
  else if xhr.status == 404
    new CurioError(json.error or 'not found')
  else if xhr.status
    new CurioError(json.error or 'server')
  else
    new CurioError('network')

unicodefy = (str) ->
  str.replace /[\u007f-\uffff]/g, (c) ->
    '\\u'+('0000'+c.charCodeAt(0).toString(16)).slice(-4)


_.assign utils,
  # collect client side error
  error: console.error.bind(console)
  debug: console.debug.bind(console)
  xhrError: xhrError
  unicodefy: unicodefy
  trunc: trunc
  btrunc: btrunc
  delayed: delayed
  makeurl: makeurl
  store: store
  isUrl: (str) ->
    /(tel|https?)\:\/\/.{3,}/i.test(str)

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils


# Load ui plugins
require './ui/foldable'
