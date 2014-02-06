utils = require 'lib/utils'
consts = require 'consts'

COOKIE_NAME = consts.LOCALE_COOKIE

i18n = window.$.i18n
i18n.dict = {}

# Export the gettext global
window.__ = _.bind(i18n._, i18n)
# only return value when has key
window.__g = (key) ->
  if i18n.dict.hasOwnProperty(key)
    return i18n._.apply(i18n, arguments)
  utils.debug 'Please translate "%s"', key

aliases =
  'en-us': 'en'
  'en-uk': 'en'
  zh: 'zh-cn'
  zht: 'zh-tw'
  zhs: 'zh-cn'

i18n.LOCALES = consts.LOCALES

detect = ->
  ret = $.cookie(COOKIE_NAME, { expires: 365, path: '/' })
  ret = ret or navigator.language or navigator.userLanguage or 'zh'
  ret = ret.toLowerCase()
  if ret in aliases
    ret = aliases[ret]
  if ret not of i18n.LOCALES
    ret = consts.DEFAULT_LOCALE
  $.cookie(COOKIE_NAME, ret)
  return ret

i18n.detect = detect
i18n.locale = detect()

xhrs = {}

i18n.fetch = (domain) ->
  return xhrs[domain] if xhrs[domain]
  jqxhr = $.get "/locales/#{i18n.locale}/#{domain}.json"
  jqxhr.done (res) ->
    i18n.load(res)
    xhrs[domain] = null
  xhrs[domain] = jqxhr
  return jqxhr

module.exports = i18n
