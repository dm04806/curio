View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
maplib =  require 'lib/map'
common = require 'views/common/utils'

{ENTER} = require 'lib/keyboard'


TT_TEMPLATES =
  suggestion: (d) ->
    "<p>#{d.name} <small class=\"district\">#{d.district}</small></p>"

LOADING_SPINNER = '<div class="loading text-center"><span class="spinner30"></span></div>'

renderInfoWindow = (poi) ->
  """
  <h4 class="place-title">#{poi.name}</h4>
  <div class="detail">
    #{poi.district or ''}#{poi.address or ''}
  </div>
  """

ZOOMS = {
  'country': 4,
  'province': 7,
  'city': 10,
  'district': 13
}

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
      opts.level = 15
    map = @map = new AMap.Map @$el.find('.map')[0], opts
    map.plugin ['AMap.ToolBar'], ->
      map.addControl new AMap.ToolBar(direction: false)
    marker = @marker = new AMap.Marker
      map: map
      position: map.getCenter()
      draggable: true
    AMap.event.addListener marker, 'dragend', => @updateByMarker()
    AMap.event.addListener map, 'dragend', => @updateByMap()
    @_ready = true
    @trigger 'ready'

  _initInfoWIndow: ->
    info = @infoWindow = new AMap.InfoWindow
      offset: new AMap.Pixel(0, -40)
    AMap.event.addListener @marker, 'dragstart', => info.close()
    info

  openInfoWindow: (pos, content) ->
    @infoWindow = @infoWindow or @_initInfoWIndow()
    if pos
      @marker.setPosition pos
    @setInfoWindow(content)
      .open @map, @marker.getPosition()

  setInfoWindow: (content) ->
    if not content
      poi = @model.attributes if not poi
      content = renderInfoWindow(poi)
    @infoWindow.setContent(content)

  initAutocomplete: (node) ->
    @$searcher = node if node
    @ready @_initAutocomplete

  _initAutocomplete: ->
    map = @map
    inputer = @$searcher
    @city = ''
    district = ''

    map.plugin ['AMap.CitySearch'], =>
      citysearch = new AMap.CitySearch()
      citysearch.getLocalCity()
      AMap.event.addListener citysearch, 'complete', (result) ->
        @city = result.city
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
            auto = new AMap.Autocomplete city: @city
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
      ps = new AMap.PlaceSearch city: @city
      ps.search keyword
      AMap.event.addListener ps, 'complete', (result) =>
        ps = null
        marker = @marker
        poi = result.poiList?.pois?[0]
        return common.notify('place.empty_search', 'warning') if not poi
        poi.district = if poi.address then district else ''
        #map.setZoom(15)
        @setPOI poi
        setTimeout =>
          @openInfoWindow()
        , 900

    inputer.on 'typeahead:selected', (e, query) ->
      district = query.district
      doSearch(query.district + query.name)

    inputer.off('keydown.mm').on 'keydown.mm', (e) ->
      if e.which == ENTER
        doSearch(this.value)
        e.preventDefault()


  stopAutoComplete: ->
    inputer = @$searcher
    inputer.typeahead('destroy')
    inputer.off('keydown.mm')

  # Do things when ready
  ready: (fn) ->
    if @_ready
      fn.call(this)
    else if @_loading
      @once 'ready', fn
    else
      @once 'ready', fn
      @_loading = true
      maplib.amap =>
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
    @model.set lat: lat, lng: lng
    if @_foreign_mode
      @setForeignLoc
        lat: lat
        lng: lng
    else
      pos = new AMap.LngLat lng,lat
      @marker.setPosition(pos)
      if not @isInsideMap(pos)
        @map.setCenter(pos)
        @map.setZoom(12)

  ##
  # Set map by AMap POI
  setPOI: (poi) ->
    pos = poi.location
    @setLatlng(pos.lat, pos.lng)
    @trigger 'poiChanged', poi
    @openInfoWindow()


  ##
  # Set map with Loc.
  setLoc: (loc) ->
    @city = loc.fullName
    return @setForeignLoc(loc) if loc.country != '中国'
    @leaveForeign()
    @map.plugin ['AMap.Geocoder'], =>
      search = new AMap.Geocoder
      search.getLocation(@city)
      AMap.event.addListener search, 'complete', (res) =>
        pos = res.geocodes[0].location
        zoom = ZOOMS[loc.level]
        @map.setCenter pos
        @map.setZoom zoom

  isInsideMap: (pos) ->
    @map.getBounds().contains(pos)

  ##
  # Update map details based on marker
  #
  updateByMarker: ->
    @infoWindow?.close()
    latlng = @marker.getPosition()
    # open a loading spinner
    @openInfoWindow(latlng, LOADING_SPINNER)
    @map.plugin ['AMap.Geocoder'], =>
      search = new AMap.Geocoder
        city: @city
        extensions: 'all'
      search.getAddress(latlng)
      AMap.event.addListener search, 'complete', (res) =>
        res = res.regeocode
        comp = res.addressComponent
        @city = comp.city or comp.province
        streetNumber = comp.streetNumber and "#{comp.streetNumber}号".replace(/[号號]+/g, '号')
        formattedAddress = res.formattedAddress.replace(comp.province, '').replace(/[号號]+/g, '号')
        address = "#{comp.city}#{comp.district}#{comp.street}#{streetNumber}"
        pois = res.pois.sort((a, b) -> a.distance - b.distance)
        poi = pois[0]
        # 优先使用 building 作为地点名
        name = comp.building or comp.neighborhood
        if poi and poi.distance < 10
          name = name or poi.name
        poi = {
          city: ''
          location: latlng
          name: name or formattedAddress
          address: address
        }
        @setPOI poi

  updateByMap: ->
    pos = @marker.getPosition()
    return if @isInsideMap(pos)
    @marker.setPosition @map.getCenter()
    @updateByMarker()

  ##
  # Update model based on POI
  #
  updateByPOI: (poi) ->
    @model.set
      address: "#{poi.district or ''}#{poi.address}"
      phone: poi.tel?.split(';').join(', ')
      name: poi.name
      lat: poi.location.lat
      lng: poi.location.lng

  ##
  # 国外地点支持
  #
  setForeignLoc: (loc) ->
    @enterForeign()
    if not @$fstatic
      @$fstatic = @$('.foreign-map .static-map')
    if loc.lat and loc.lng
      pos = [loc.lat,loc.lng].join(',')
      opts = {
        size: '500x255'
        center: pos
        markers: pos
        zoom: 11
      }
      @model.set
        lat: loc.lat
        lng: loc.lng
        address: loc.fullName
    else
      opts = {
        size: '500x255'
        center: loc.fullName
      }
      @model.set
        address: loc.fullName
    @$fstatic.html("<img src=\"#{maplib.gstaticMap(opts)}\" >")

  ##
  # Show static map (for outside China)
  #
  enterForeign: ->
    @_foreign_mode = true
    @$el.addClass('foreign-mode')
    @stopAutoComplete()
    inputer = @$searcher
    inputer.on 'keydown.mm', (e) =>
      if e.which == ENTER
        @setForeignLoc({
          fullName: inputer.val()
        })
        e.preventDefault()

  leaveForeign: ->
    @_foreign_mode = false
    @$el.removeClass('foreign-mode')
    @initAutocomplete()

  listen:
    'addedToDOM': 'showMap'
    'poiChanged': 'updateByPOI'
