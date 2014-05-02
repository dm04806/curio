Model = require 'models/base/model'
{btrunc} = require 'lib/utils'

getAvatar = (id) ->
  "/images/avatar/#{id % 5}.jpg"

module.exports = class Subscriber extends Model
  kind: 'subscriber'
  defaults: ->
    oid: null
    phone: null
    name: null
    active: true

  url: ->
    "#{@apiRoot}/medias/#{@get 'media_id'}/subscribers/#{@id}"

  set: ->
    super
    attrs = @attributes
    attrs.avatar = attrs.headimgurl or getAvatar(attrs.id)
    attrs.name = attrs.nickname or attrs.name or btrunc(attrs.oid, 8, '')
    attrs.full_city = "#{attrs.province or ''}#{attrs.city or ''}"
