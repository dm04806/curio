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

    @marker = new AMap.Marker
      map: map
      position: map.getCenter()
      draggable: true

    @infoWindow = new AMap.InfoWindow
      position: center
      offset: new AMap.Pixel(0, -40)
      content: @model.get 'address'

    @_ready = true
    @trigger 'ready'

  initAutocomplete: ->
    node = @$searcher = @$el.find('input.searcher')
    return if not node[0]
    @ready @_initAutocomplete

  _initAutocomplete: ->
    map = @map

    city = ''
    district = ''

    inputer = @$searcher

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
        autoselect: false
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
        info = @infoWindow
        poi = result.poiList?.pois?[0]
        return common.notify('place.empty_search', 'warning') if not poi
        loc = poi.location
        pos = new AMap.LngLat loc.lng, loc.lat
        map.setCenter(pos).setZoom(15)
        marker.setPosition(pos)
        setTimeout ->
          info.setContent(renderInfoWindow(poi)).open(map, pos)
          # pan the map, to leave room for info window
          map.panBy(-20, 60)
        , 600
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
    @redraw()
    @initAutocomplete() if not @$searcher
    if not @$searcher.val()
      @$searcher.focus()

  shrink: ->
    @$el.removeClass('large')
    @redraw()

  redraw: ->
    return unless @map
    AMap.event.trigger @map, 'resize'

  listen:
    'addedToDOM': 'showMap'
