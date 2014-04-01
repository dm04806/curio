Model = require 'models/base/model'

Subscriber = require '../subscriber'
MessageCollection = require 'models/message/collection'

module.exports = class Media extends Model
  kind: 'media'
  defaults:
    oid: null
    uid: null
    name: null
    avatar: '/images/avatar/default.jpg'
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
    subscriber: (id) ->
      if id.id
        id = id.id
      ret = new Subscriber id: id
      ret.media_id = @id
      return ret
    messages: (params) ->
      coll = new MessageCollection [], params: params
      coll.media = this
      return coll
