Subscriber = require 'models/subscriber'
MessageIndexView = require 'views/message-view'

module.exports = class SubscriberView extends MessageIndexView
  template: require './templates/show'
  region: 'main'
  regions:
    'listable': '.messages'
  render: ->
    super

