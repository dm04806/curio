Collection = require 'models/base/collection'
Subscriber = require 'models/subscriber'
Message = require 'models/message'

module.exports = class MessageCollection extends Collection
  urlRoot: ->
    "#{@media.url()}/messages"
  parse: () ->
    ret = super
    ret.map (item) =>
      if item.subscriber
        item.subscriber = new Subscriber(item.subscriber)
      else if @subscriber
        item.subscriber = @subscriber_id
      else
        item.subscriber = new Subscriber subscriber_id: item.subscriber_id
      return item
    return ret
