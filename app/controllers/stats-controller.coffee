HomeController = require './home-controller'
mediator = require 'mediator'

StatsHomeView = require 'views/stats-view'

module.exports = class StatsController extends HomeController
  index: ->
    @view = new StatsHomeView

