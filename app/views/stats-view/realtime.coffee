TimeLineChart = require 'views/graph/timeline'


module.exports = class RealtimeChart extends TimeLineChart
  timeFormat: '%H:%M'
  tickInterval: '2 hour'
