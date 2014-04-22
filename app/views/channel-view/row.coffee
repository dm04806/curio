View = require 'views/base/view'
mediator = require 'mediator'

module.exports = class ChannelRow extends View
  noWrap: true
  template: require './templates/row'
