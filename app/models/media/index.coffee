Model = require 'models/base/model'
Responder = require 'models/responder'
Subscriber = require 'models/subscriber'
Message = require 'models/message'
MessageCollection = require 'models/message/collection'
Place = require 'models/place'
Channel = require 'models/channel'
ChannelCollection = require 'models/channel/collection'
Menu = require 'models/menu'
{WEBOT_ROOT} = require 'consts'

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

  # whether this media can use advance API
  canAdvance: ->
    attrs = @attributes
    'wx_appkey' of attrs and 'wx_secret' of attrs

  loaders:
    admins:
      url: '/admins'
      parse: (res) -> res.items

  relations:
    hasOne:
      responder: Responder
      subscriber: Subscriber
      menu: Menu
    hasMany:
      subscribers: Subscriber
      messages: MessageCollection
      channels: ChannelCollection
      places: Place

  serialize: ->
    ret = _.clone(@attributes)
    ret.webotUrl = @webotUrl()
    ret

  webotUrl: (uid) ->
    "#{WEBOT_ROOT}#{uid or @get 'uid'}"

  # Create async job
  addJob: (jobname, data) ->
    url = "#{@url()}/jobs/#{jobname}"
    xhr = $.send(url, data, { type: 'PUT' })

