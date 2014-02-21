ListableView = require 'views/base/listable'
Subscriber = require 'models/subscriber'

thead = require './templates/subscriber_thead'

module.exports = class SubscriberIndexView extends ListableView
  _model: Subscriber
  template: require './templates/subscriber_index'
  itemTemplate: require './templates/subscriber_row'
  debug: true
  context: ->
    total: @collection.total
    thead: thead

