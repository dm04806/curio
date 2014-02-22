var API_ROOT, DEBUG, SITE_ROOT

DEBUG = typeof window !== "undefined" && window !== null ? window.DEBUG : void 0

SITE_ROOT = 'http://mesa.curiositychina.com'
API_ROOT = 'http://api.curiositychina.com'

if (DEBUG) {
  SITE_ROOT = 'http://www.curio.com'
  API_ROOT = 'http://api.curio.com'
}

module.exports = {
  DEBUG: DEBUG,
  SITE_ROOT: SITE_ROOT,
  API_ROOT: API_ROOT,
  LOCALE_COOKIE: 'locale',
  DEFAULT_LOCALE: 'zh-cn',
  LOCALES: {
    'zh-cn': '中文(简体)',
    en: 'English'
  }
}
