"use strict";
var API_ROOT, DEBUG, SITE_ROOT, API_ROOT, WEBOT_ROOT, PAGE_ROOT, BMAP_AK, GMAP_AK, AMAP_AK

DEBUG = typeof window !== "undefined" && window !== null ? window.DEBUG : void 0

SITE_ROOT = 'http://wx.curio.im'
API_ROOT = '/api'
WEBOT_ROOT = 'http://curio.im/webot'
PAGE_ROOT = 'http://curio.im'
AMAP_AK = '8bee5fb2af355c5727ed397576f47ce3' // 高德
BMAP_AK = '2KGr6T5CuGNza0kvrCeS5XrT' // baidu map
GMAP_AK = 'iAIzaSyDQUDsTP7C-_8miDnewE1uNqhGr2VTxHoA' // google map

if (DEBUG) {
  SITE_ROOT = window.location.origin
  AMAP_AK = '1cff40b555f2220b79e9fe6f97cb3450'
  BMAP_AK = ''
  GMAP_AK = 'AIzaSyAbaxTb0pp1qnRBVSJi5qQJmMoxgOrDbDU'
  PAGE_ROOT = 'http://curio.com'
}

module.exports = {
  DEBUG: DEBUG,
  AMAP_AK: AMAP_AK,
  BMAP_AK: BMAP_AK,
  GMAP_AK: GMAP_AK,
  SITE_ROOT: SITE_ROOT,
  API_ROOT: API_ROOT,
  WEBOT_ROOT: WEBOT_ROOT,
  PAGE_ROOT: PAGE_ROOT,
  LOCALE_COOKIE: 'locale',
  DEFAULT_LOCALE: 'zh-cn',
  LOCALES: {
    'zh-cn': '中文(简体)',
    en: 'English'
  }
}
