mediator = require 'mediator'
MainView = require 'views/common/main'
TimeLineChart = require 'views/graph/timeline'

Realtime = require 'views/stats-view/realtime'

module.exports = class HomeMain extends MainView
  template: require './templates/home'

  context: ->
    console.log @data
    yesterday: @data['7days']
    media: mediator.media.attributes

  showGraph: ->
    console.log @data
    data = @data
    @subview 'realtime', new Realtime
      container: '#home-realtime'
      data: data['1day']

    @subview 'last7', new TimeLineChart
      container: '#last7-chart'
      tickInterval: 'day'
      data: data['7days']

    @subview 'last30', new TimeLineChart
      container: '#last30-chart'
      data: data['30days']

  listen:
    'addedToDOM': 'showGraph'
