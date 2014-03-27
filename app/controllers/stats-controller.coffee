HomeController = require './home-controller'
mediator = require 'mediator'

module.exports = class StatsController extends HomeController
  main: require 'views/stats-view'

