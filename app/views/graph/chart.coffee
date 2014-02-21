View = require 'views/base/view'

module.exports = class ChartView extends View
  autoRender: true
  optionNames: View::optionNames.concat [
    'data', 'formats', 'scales', 'chartOptions'
  ]
  noWrap: true
  getData: ->
    return @data or []
  getChart: (options) ->
    @chart = @nvModel()
  template: ->
    '<svg></svg>'
  getDatum: ->
    d3.select(@el).datum(@getData())
  render: ->
    super
    nv.addGraph =>
      chart = @getChart()
      if @chartOptions
        chart.options(@chartOptions)
      @getDatum().call(chart)
      return chart
    @_resize = (=> @update())
    $(window).on 'resize', @_resize
  dispose: ->
    if @_resize
      $(window).off 'resize', @_resize
    super
  update: ->
    @chart?.update()
