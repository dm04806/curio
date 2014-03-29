var API_ROOT, DEBUG, SITE_ROOT

DEBUG = typeof window !== "undefined" && window !== null ? window.DEBUG : void 0

SITE_ROOT = 'http://wx.curio.im'
API_ROOT = '/api'

if (DEBUG) {
  SITE_ROOT = window.location.origin
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
