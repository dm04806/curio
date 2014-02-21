Line = require './line'

module.exports = class TimeLine extends Line
  timeFormat: '%m/%d'
  tickByTime: true
  optionNames: Line::optionNames.concat ['timeFormat', 'tickByTime']
  xAxis: (axis) ->
    timescale = d3.time.scale()
    #timescale.domain(@chart.xAxis.domain)
    #@chart.lines.scatter.xScale(timescale)
    axis.showMaxMin(false)
    #axis.scale(timescale)
    axis.tickFormat (d) =>
      d3.time.format(@timeFormat)(new Date(d))
    if @tickByTime
      axis.tickValues (d) ->
        return d[0].values.map((item) -> item.x)
