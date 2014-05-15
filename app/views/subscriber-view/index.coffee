CollectionView = require 'views/base/collection'
Subscriber = require 'models/subscriber'
mediator = require 'mediator'
common = require 'views/common/utils'

thead = require './templates/thead'

module.exports = class SubscriberIndexView extends CollectionView
  template: require './templates/index'
  itemView: require './row'

  context: ->
    total: @collection.total
    thead: thead
    fallback:
      title: 'subscribers.noresult'

  toSync: (node) ->
    node.attr('disabled', true)
    mediator.media.addJob('sync-subscriber').done ->
      common.notify 'subscribers.sync.ing', 'success'
    .error ->
      common.notify 'subscribers.sync.start_fail'

