Chart = require './chart'


module.exports = class LineChart extends Chart
  optionNames: Chart::optionNames.concat ['datumKeys']
  nvModel: nv.models.lineChart
  className: 'line-chart'
  xAxis: ',.2f'
  x2Axis: ',.2f'
  yAxis: Chart.axes.integer
  y2Axis: Chart.axes.integer
  datumKey:
    x: 'x'
    y: 'y'
  chartOptions:
    margin:
      left: 40
      bottom: 30
      right: 25
    useInteractiveGuideline: true
    transitionDuration: 350

  getChart: (options) ->
    chart = super
    for k in ['xAxis', 'yAxis', 'x2Axis', 'y2Axis']
      # update axises
      axis = chart[k]
      continue if not axis
      f = @[k]
      if 'string' == typeof f
        @[k] = axis.tickFormat(d3.format(f))
      else
        @[k] = @[k](axis)
    chart.x (d) =>
      d[@datumKey.x] or 0
    chart.y (d) =>
      d[@datumKey.y] or 0
    return chart
  #getDatum: ->
    #super.transition().duration(400)
