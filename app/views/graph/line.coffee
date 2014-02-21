Chart = require './chart'

module.exports = class LineChart extends Chart
  nvModel: nv.models.lineChart
  className: 'line-chart'
  xAxis: ',.2f'
  yAxis: 'n'
  chartOptions:
    margin:
      left: 40
      bottom: 30
      right: 20
  getChart: (options) ->
    chart = super
    chart.useInteractiveGuideline(true)
    for k in ['xAxis', 'yAxis']
      axis = chart[k]
      f = @[k]
      if 'string' == typeof f
        @[k] = axis.tickFormat(d3.format(f))
      else
        @[k] = @[k](axis)
    return chart
  #getDatum: ->
    #super.transition().duration(400)
