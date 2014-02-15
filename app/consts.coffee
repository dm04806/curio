DEBUG = window?.DEBUG

SITE_ROOT = 'http://www.curiositychina.com'
API_ROOT = 'http://api.curiositychina.com'

if DEBUG
  SITE_ROOT = 'http://www.curio.com'
  API_ROOT = 'http://api.curio.com'

module.exports =
  DEBUG: !DEBUG
  SITE_ROOT: SITE_ROOT
  API_ROOT: API_ROOT
  LOCALE_COOKIE: 'locale'
  DEFAULT_LOCALE: 'zh-cn'
  #LOCALES_LIST: ['zh-cn', 'en']
  LOCALES:
    'zh-cn': '中文(简体)'
    en: 'English'
