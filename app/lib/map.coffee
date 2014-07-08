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
  if window.AMap
    cb()
  else
    amap_start(cb)


qs = Chaplin.utils.querystring


isRentina = window.devicePixelRatio >= 1.5
mapbox_token = "pk.eyJ1Ijoia3RtdWQiLCJhIjoiaGJfN29BWSJ9.t0tAn4u2xYYFTl7b6-edKg"

exports.gstaticMap = (opts) ->
  _.defaults opts,
    size: '600x200'
    zoom: 13
    maptype: 'roadmap'
  if not opts.lat
    opts.lat = 0
    opts.lng = 120
    opts.zoom = 1
  #"http://maps.google.cn/maps/api/staticmap?key=#{GMAP_AK}&#{qs.stringify(opts)}"
  #"http://maps.googleapis.com/maps/api/staticmap?key=#{GMAP_AK}&#{qs.stringify(opts)}"
  center = [opts.lng, opts.lat].join(',')
  size = opts.size.replace('*', 'x')
  retina = if isRentina then '@2x' else ''
  "http://api.tiles.mapbox.com/v4/ktmud.ine3g1oi/pin-s+f44(#{center})/#{center},#{opts.zoom}/#{size}#{retina}.png?access_token=#{mapbox_token}"

