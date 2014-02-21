Subscriber = require 'models/subscriber'
MessageIndexView = require './message_index'

module.exports = class SubscriberView extends MessageIndexView
  template: require './templates/subscriber_show'
  region: 'main'
  regions:
    'listable': '.messages'
  render: ->
    super

