Model = require 'models/base/model'

Subscriber = require '../subscriber'
MessageCollection = require 'models/message/collection'

module.exports = class Media extends Model
  kind: 'media'
  defaults:
    oid: null
    uid: null
    name: null
    wx_appkey: null
    wx_secret: null
    wx_token: null
    desc: null

  loaders:
    admins:
      url: '/admins'
      parse: (res) -> res.items

  relations:
    subscribers: Subscriber
    subscriber: (params) ->
      ret = new Subscriber id: params.id
      ret.media_id = @id
      return ret
    messages: (params, subscriber) ->
      if params instanceof Subscriber
        subscriber = params
        params = { subscriber_id: subscriber.id }
      coll = new MessageCollection [], params: params
      coll.media = this
      coll.subscriber = subscriber
      return coll
