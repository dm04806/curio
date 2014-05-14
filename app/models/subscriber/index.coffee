Model = require 'models/base/model'
{btrunc} = require 'lib/utils'

TWO_DAYS = 36e5 * 48


fakeAvatar = (id) ->
  "/images/avatar/#{id % 5}.jpg"

getSex = (val) ->
  switch val
    when 1 then __('male')
    when 2 then __('female')
    else __('unknown')

module.exports = class Subscriber extends Model
  kind: 'subscriber'
  defaults: ->
    oid: null
    phone: null
    name: null
    active: true

  recentlyActived: ->
    new Date - @get('updated_at') < TWO_DAYS

  url: ->
    # always include props
    "#{@apiRoot}/medias/#{@get 'media_id'}/subscribers/#{@id}?include=props"

  serialize: ->
    attrs = @toJSON()
    attrs.sex = getSex(attrs.sex)
    attrs.avatar = attrs.headimgurl or fakeAvatar(attrs.id)
    attrs.name = attrs.nickname or attrs.name or btrunc(attrs.oid, 8, '')
    attrs.full_city = "#{attrs.province or ''}#{attrs.city or ''}"
    attrs

