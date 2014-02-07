# Application-specific utilities
# ------------------------------
{SITE_ROOT} = require 'consts'

$.fn.anim = (cls) ->
  @removeClass("animated #{this[0]._last_anim or ''}")
  this[0]._last_anim = cls
  setTimeout =>
    @addClass("animated #{cls}")


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
