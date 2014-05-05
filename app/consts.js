"use strict";

var API_ROOT, DEBUG, SITE_ROOT, API_ROOT, WEBOT_ROOT

DEBUG = typeof window !== "undefined" && window !== null ? window.DEBUG : void 0

SITE_ROOT = 'http://wx.curio.im'
API_ROOT = '/api'
WEBOT_ROOT = 'http://curio.im/webot/'

if (DEBUG) {
  SITE_ROOT = window.location.origin
}

module.exports = {
  DEBUG: DEBUG,
  SITE_ROOT: SITE_ROOT,
  API_ROOT: API_ROOT,
  WEBOT_ROOT: WEBOT_ROOT,
  LOCALE_COOKIE: 'locale',
  DEFAULT_LOCALE: 'zh-cn',
  LOCALES: {
    'zh-cn': '中文(简体)',
    en: 'English'
  }
}
