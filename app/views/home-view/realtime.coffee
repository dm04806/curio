View = require 'views/base/view'


module.exports = class HomeRealTime extends View
  autoRender: true
  noWrap: true
  template: require './templates/realtime'
  context: ->
    activities: _.range(3)
