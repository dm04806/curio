View = require 'views/base'

module.exports = class HomeMain extends View
  autoRender: true
  className: 'main-container'
  template: require './templates/home'

