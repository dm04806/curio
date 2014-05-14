CollectionView = require 'views/base/collection'
Subscriber = require 'models/subscriber'

thead = require './templates/thead'

module.exports = class SubscriberIndexView extends CollectionView
  template: require './templates/index'
  itemView: require './row'

  context: ->
    total: @collection.total
    thead: thead
    fallback:
      title: 'subscribers.noresult'

