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

store.remove = (key) ->
  utils.debug '[storege delete] %s', key
  localStorage.removeItem(key)

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


String.prototype.blength = () ->
  this.replace(/\n\r/g, '\n').replace(/[^\x00-\xff]/g, 'xx').length

String.prototype.btrunc = (limit) ->
  btrunc(this, limit)


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


_.assign utils,
  # collect client side error
  error: console.error.bind(console)
  debug: console.debug.bind(console)
  trunc: trunc
  btrunc: btrunc
  delayed: delayed
  makeurl: makeurl
  store: store

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils


# Load ui plugins
require './ui/foldable'
