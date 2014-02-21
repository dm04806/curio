Model = require 'models/base/model'

getAvatar = (id) ->
  "/images/avatar/#{id % 5}.jpg"

module.exports = class Subscriber extends Model
  kind: 'subscriber'
  defaults:
    oid: null
    phone: null
    name: null
    active: true
  urlPath: ->
    return super unless @media_id
    "/medias/#{@media_id}/subscribers"
  initialize: ->
    super
    @set 'avatar', (@get 'headimgurl') or getAvatar(@id)
