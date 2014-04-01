Subscriber = require 'models/subscriber'
MessageIndexView = require 'views/message-view'

module.exports = class SubscriberView extends MessageIndexView
  template: require './templates/dialog'
  listableSelector: '#message-dialog'
  region: 'main'

