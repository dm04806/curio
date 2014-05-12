View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
gmap =  require 'lib/map'

##
# 在地图上标记地点
#
module.exports = class MapMarker extends View
  autoRender: true
  template: require './templates/map_marker'
  render: ->
    super
    gmap @showMap.bind(this)
  showMap: ->
    options =
      zoom: 4
      center: new google.maps.LatLng(30, 120)
    map = new google.maps.Map @el, options
    console.log map, @el
