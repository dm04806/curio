Model = require 'models/base/model'

Subscriber = require '../subscriber'

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
    messages: require '../message'
    subscribers: Subscriber
    subscriber: (params) ->
      ret = new Subscriber id: params.id
      ret.media_id = @id
      return ret

