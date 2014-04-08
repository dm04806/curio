Line = require './line'

ONE_HOUR = 3600 * 1000
ONE_DAY = 24 * ONE_HOUR


parseInterval = (interval) ->
  step = 1
  if ' ' in interval
    tmp = interval.split(' ')
    step = tmp[0]
    interval = tmp[1]
  return [interval, step]


module.exports = class TimeLine extends Line
  timeFormat: '%m/%d'
  tickInterval: false # 坐标轴渐进的时间间隔, false means default
  optionNames: Line::optionNames.concat ['timeFormat', 'tickInterval']
  datumKey:
    x: 'date'
    y: 'count'

  timescale: ->
    return @_timescale if @_timescale
    #.utc() # use UTC time, so dots can align correctly
    timescale = d3.time.scale()
    @_timescale = timescale

  getChart: ->
    chart = super
    chart.x (d) ->
      new Date(d.date)

  xAxis: (axis) ->
    timescale = @timescale()
    @chart.xScale?(timescale)
    axis.tickFormat (d) =>
      d3.time.format(@timeFormat)(new Date(d))

    [interval, step] = parseInterval(@tickInterval)
    if interval of d3.time
      timescale.nice(d3.time[interval])
      axis.tickValues (d) ->
        timescale.ticks(d3.time[interval], step)

  x2Axis: (axis) ->
    axis.tickFormat (d) =>
      d3.time.format(@timeFormat)(new Date(d))
