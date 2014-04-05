Model = require 'models/base/model'
Responder = require 'models/responder'

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

    # All custom autorely rules
    responder:
      url: '/responder'
      #cache: true  # will cache the result on model
      parse: (res) ->
        new Responder res

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
