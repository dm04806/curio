mediator = require 'mediator'
MainView = require 'views/common/main'
TimeLineChart = require 'views/graph/timeline'

Realtime = require 'views/stats-view/realtime'

module.exports = class HomeMain extends MainView
  template: require './templates/home'

  context: ->
    media: mediator.media.attributes

  showGraph: ->

    mediator.media.load 'stats/incoming', (err, res) =>

      @subview 'realtime', new Realtime
        container: '#home-realtime'
        data: res['1day']

      @subview 'last7', new TimeLineChart
        container: '#last7-chart'
        tickInterval: 'day'
        data: res['7days']

      @subview 'last30', new TimeLineChart
        container: '#last30-chart'
        data: res['30days']

  listen:
    'addedToDOM': 'showGraph'
