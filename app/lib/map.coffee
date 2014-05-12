# Google Maps help utilities
{GMAP_AK} = require 'consts'

MAP_JS = "//maps.googleapis.com/maps/api/js?key=#{GMAP_AK}&sensor=false"


$.cachedScript = (url, options) ->
  options = $.extend(options or {}, {
    dataType: 'script'
    cache: true,
    url: url
  })
  return jQuery.ajax options

start = (cb) ->
  cb_name = '_gmap_callback_'
  if not cb
    throw new Error('Must provide a callback')
  js = "#{MAP_JS}&callback=#{cb_name}"
  window[cb_name] = ->
    cb()
    delete window[cb_name]
  $.cachedScript js

module.exports = (cb) ->
  if google?.maps
    cb()
  else
    start(cb)

module.exports.start = start
