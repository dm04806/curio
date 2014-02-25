ListableView = require 'views/base/listable'
Subscriber = require 'models/subscriber'

thead = require './templates/thead'

module.exports = class SubscriberIndexView extends ListableView
  _model: Subscriber
  template: require './templates/index'
  itemTemplate: require './templates/row'
  context: ->
    total: @collection.total
    thead: thead

