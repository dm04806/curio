utils = require 'lib/utils'
consts = require 'consts'

COOKIE_NAME = consts.LOCALE_COOKIE

i18n = window.$.i18n

# Export the gettext global
window.__ = _.bind(i18n._, i18n)

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

i18n.fetch = (domain) ->
  jqxhr = $.getJSON "/locales/#{i18n.locale}/#{domain}.json"
  jqxhr.done (res) ->
    i18n.load(res)
  return jqxhr

module.exports = i18n
