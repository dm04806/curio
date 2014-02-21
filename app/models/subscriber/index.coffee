Model = require 'models/base/model'

getAvatar = (id) ->
  "/images/avatar/#{id % 5}.jpg"

module.exports = class Subscriber extends Model
  kind: 'subscriber'
  defaults: ->
    oid: null
    phone: null
    name: null
    active: true
  urlPath: ->
    return unless @media_id
    "/medias/#{@media_id}/subscribers"
  set: ->
    super
    attrs = @attributes
    attrs.avatar = attrs.headimgurl or getAvatar(attrs.id)
    attrs.name = attrs.name or attrs.oid
