#
# Async load of map libraries
#
{AMAP_AK,GMAP_AK} = require 'consts'

MAP_JS = "http://webapi.amap.com/maps?v=1.2&key=#{AMAP_AK}"
#MAP_JS = "//maps.googleapis.com/maps/api/js?key=#{GMAP_AK}&sensor=false&libraries=places"



$.cachedScript = (url, options) ->
  options = $.extend(options or {}, {
    dataType: 'script'
    cache: true,
    url: url
  })
  return jQuery.ajax options

amap_start = (cb) ->
  cb_name = '_map_callback_'
  if not cb
    throw new Error('Must provide a callback')
  js = "#{MAP_JS}&callback=#{cb_name}"
  window[cb_name] = ->
    cb()
    delete window[cb_name]
  $.cachedScript js

exports.amap = (cb) ->
  if window.Amap
    cb()
  else
    amap_start(cb)


qs = Chaplin.utils.querystring

exports.gstaticMap = (opts) ->
  _.defaults opts,
    size: '600x200'
    maptype: 'roadmap'
  "http://maps.google.cn/maps/api/staticmap?#{qs.stringify(opts)}"

