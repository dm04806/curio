View = require 'views/base'

module.exports = class HeaderView extends View
  autoRender: true
  el: 'header'
  template: require './templates/header'

