"use strict";
var API_ROOT, DEBUG, SITE_ROOT, API_ROOT, WEBOT_ROOT, BMAP_AK, GMAP_AK

DEBUG = typeof window !== "undefined" && window !== null ? window.DEBUG : void 0

SITE_ROOT = 'http://wx.curio.im'
API_ROOT = '/api'
WEBOT_ROOT = 'http://curio.im/webot/'
BMAP_AK = '2KGr6T5CuGNza0kvrCeS5XrT'
GMAP_AK = 'iAIzaSyDQUDsTP7C-_8miDnewE1uNqhGr2VTxHoA'

if (DEBUG) {
  SITE_ROOT = window.location.origin
  GMAP_AK = 'AIzaSyAbaxTb0pp1qnRBVSJi5qQJmMoxgOrDbDU'
  BMAP_AK = ''
}

module.exports = {
  DEBUG: DEBUG,
  BMAP_AK: BMAP_AK,
  GMAP_AK: GMAP_AK,
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
