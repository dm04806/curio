View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
amap =  require 'lib/map'
common = require 'views/common/utils'

{ENTER} = require 'lib/keyboard'


TT_TEMPLATES =
  suggestion: (d) ->
    "<p>#{d.name} <small class=\"district\">#{d.district}</small></p>"


renderInfoWindow = (poi) ->
  """
  <h4 class="place-title">#{poi.name}</h4>
  <div class="detail">
    #{poi.city or ''}#{poi.address or ''}
  </div>
  """

##
# 在地图上标记地点
#
module.exports = class MapMarker extends View
  autoRender: true
  className: 'map-marker'
  template: require './templates/map_marker'

  render: ->
    super

  showMap: ->
    @ready @_showMap

  _showMap: ->

    opts =
      resizeEnable: true

    if @model.get 'lat'
      center = new AMap.LngLat @model.get('lng'), @model.get('lat')
    if center
      opts.center = center
      opts.level = 12

    map = @map = new AMap.Map @$el.find('.map')[0], opts
    map.plugin ['AMap.ToolBar'], ->
      map.addControl new AMap.ToolBar(direction: false)

    marker = @marker = new AMap.Marker
      map: map
      position: map.getCenter()
      draggable: true

    AMap.event.addListener marker, 'dragend', => @updateByMarker()

    @_ready = true
    @trigger 'ready'


  openInfoWindow: (poi, pos) ->
    if not info = @infoWindow
      info = @infoWindow = new AMap.InfoWindow
        offset: new AMap.Pixel(0, -40)
      AMap.event.addListener @marker, 'dragstart', => info.close()
    if not poi
      poi = @model.attributes
    info.setContent(renderInfoWindow(poi))
      .open @map, @marker.getPosition()
    @map.panBy(-10, 30)


  initAutocomplete: (node) ->
    @$searcher = node
    @ready @_initAutocomplete

  _initAutocomplete: ->
    map = @map
    inputer = @$searcher
    city = ''
    district = ''

    map.plugin ['AMap.CitySearch'], =>
      citysearch = new AMap.CitySearch()
      citysearch.getLocalCity()
      AMap.event.addListener citysearch, 'complete', (result) ->
        city = result.city

    map.plugin ['AMap.Autocomplete', 'AMap.PlaceSearch'], =>
      bb = new Bloodhound
        datumTokenizer: (d) -> [d.name, d.district]
        queryTokenizer: Bloodhound.tokenizers.whitespace
        remote:
          url: '%QUERY'
          filter: (res) ->
            res.filter (item) -> item.district.toString()
          transport: (url, opt, success, error) ->
            keyword = decodeURIComponent(url)
            auto = new AMap.Autocomplete city: city
            auto.search keyword
            AMap.event.addListener auto, 'complete', (obj) ->
              success(obj.tips or [])
      bb.initialize()

      inputer.typeahead({
        autoselect: true
      }, {
        templates: TT_TEMPLATES
        displayKey: 'name'
        name: 'amap-places'
        source: bb.ttAdapter()
      })

      inputer.off 'blur.tt'

    # act as a loading indicator, to prevent duplicate request
    ps = null

    doSearch = (keyword) =>
      return if ps
      ps = new AMap.PlaceSearch city: city
      ps.search keyword
      AMap.event.addListener ps, 'complete', (result) =>
        ps = null
        marker = @marker
        poi = result.poiList?.pois?[0]
        return common.notify('place.empty_search', 'warning') if not poi
        loc = poi.location
        pos = new AMap.LngLat loc.lng, loc.lat
        map.setCenter(pos).setZoom(15)
        marker.setPosition(pos)
        setTimeout =>
          @openInfoWindow()
        , 900
        if poi.address
          poi.city = district or city
        @trigger 'searched', poi

    inputer.on 'typeahead:selected', (e, query) ->
      district = query.district
      doSearch(query.district + query.name)

    inputer.on 'keydown', (e) ->
      if e.which == ENTER
        doSearch(this.value)
        e.preventDefault()


  # Do things when ready
  ready: (fn) ->
    if @_ready
      fn.call(this)
    else if @_loading
      @once 'ready', fn
    else
      @once 'ready', fn
      @_loading = true
      amap =>
        @_ready = true
        @_loading = null
        @trigger 'ready'

  enlarge: ->
    @$el.addClass('large')
    @trigger 'enlarge'
    @redraw()

  shrink: ->
    @$el.removeClass('large')
    @trigger 'shrink'
    @redraw()

  redraw: ->
    return unless @map
    AMap.event.trigger @map, 'resize'

  setLatlng: (lat, lng) ->
    @model.set
      lat: lat
      lng: lng

  ##
  # Update map details based on marker
  #
  updateByMarker: ->
    @infoWindow?.close()
    latlng = @marker.getPosition()
    @setLatlng(latlng.lat, latlng.lng)
    @map.plugin ['AMap.Geocoder'], =>
      search = new AMap.Geocoder()
      search.getAddress(latlng)
      AMap.event.addListener search, 'complete', (res) =>
        console.log arguments


  listen:
    'addedToDOM': 'showMap'
