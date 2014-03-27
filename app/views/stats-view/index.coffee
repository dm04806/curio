mediator = require 'mediator'
MainView = require 'views/common/main'
TimeLineChart = require 'views/graph/timeline'

RealTime = require 'views/stats-view/realtime'


module.exports = class HomeMain extends MainView
  template: require './templates/home'
  showGraph: ->
    mediator.media.load 'stats/incoming', { periods: '30days' }, (err, res) =>
      view = @subview 'last30', new TimeLineChart
        container: '#last30-chart'
        data: res['30days']
  listen:
    'addedToDOM': 'showGraph'

