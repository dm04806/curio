View = require 'views/base'

module.exports = class HeaderView extends View
  autoRender: true
  noWrap: true
  template: require './templates/header'

