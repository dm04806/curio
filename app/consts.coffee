production = false

SITE_ROOT = 'http://www.curio.com'
API_ROOT = 'http://api.curio.com'

if production
  SITE_ROOT = 'http://www.curiositychina.com'
  API_ROOT = 'http://api.curiositychina.com'

module.exports =
  DEBUG: !production
  SITE_ROOT: SITE_ROOT
  API_ROOT: API_ROOT
  LOCALE_COOKIE: 'locale'
  DEFAULT_LOCALE: 'zh-cn'
  LOCALES:
    'zh-cn': '中文(简体)'
    en: 'English'
