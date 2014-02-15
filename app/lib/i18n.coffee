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
  console.warn 'Please translate "%s"', key

aliases =
  'en-us': 'en'
  'en-uk': 'en'
  zh: 'zh-cn'
  zht: 'zh-tw'
  zhs: 'zh-cn'

i18n.LOCALES = consts.LOCALES

detect = (locale) ->
  locale = locale or $.cookie(COOKIE_NAME)
  locale = locale or navigator.language or navigator.userLanguage or 'zh'
  locale = locale.toLowerCase()
  utils.debug 'language: %s', locale
  if locale of aliases
    utils.debug 'language aliase: %s -> %s', locale, aliases[locale]
    locale = aliases[locale]
  if locale not of i18n.LOCALES
    locale = consts.DEFAULT_LOCALE
  return locale

i18n.setLocale = (locale) ->
  locale = detect(locale)
  $.removeCookie(COOKIE_NAME)
  $.cookie(COOKIE_NAME, locale, { expires: 365, path: '/' })
  return locale

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
