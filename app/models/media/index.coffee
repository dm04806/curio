Model = require 'models/base/model'

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
    messages: (opts) ->
      Message = require '../message'
      opts = opts or {}
      opts.media_id = @id
      Message.collection opts
