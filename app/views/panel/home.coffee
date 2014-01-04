View = require 'views/base'

module.exports = class HomeMain extends View
  el: '#main'
  template: require './templates/home'
