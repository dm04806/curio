View = require 'views/base/view'
utils = require 'lib/utils'
colors = require './colors'

nv.utils.defaultColor = ->
  c = colors.five2
  (d, i) ->
    d.color || c[i % c.length]


localize_keys = (obj) ->
  for k of obj
    if 'object' is typeof obj[k]
      localize_keys(obj[k])
    else if k == 'key'
      obj.key = __(obj.key)


class ChartView extends View
  autoRender: true
  noWrap: true
  nvModel: null

  getData: ->
    ret = @data or []
    if !Array.isArray(ret)
      ret = Object.keys(ret).map (k) ->
        key: __(k)
        values: ret[k]
    else
      localize_keys(ret)
    return ret

  getChart: (options) ->
    @chart = @nvModel()

  template: ->
    '<svg></svg>'

  getDatum: ->
    d3.select(@el).datum(@getData())

  render: ->
    super
    chart = @getChart()
    if @chartOptions
      chart.options(@chartOptions)

    nv.addGraph =>
      @getDatum().call(chart)
      @trigger('datumBind')
      return chart

    @_resize = utils.delayed(=> @update())
    $(window).on 'resize', @_resize

  dispose: ->
    if @_resize
      $(window).off 'resize', @_resize
    super

  update: ->
    @chart?.update()


ChartView.axes =
  integer: (axis) ->
    axis.tickFormat d3.format(',d')
    axis

module.exports = ChartView

