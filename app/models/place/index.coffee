Model = require 'models/base/model'
Channel = require 'models/channel'

{PAGE_ROOT} = require 'consts'

module.exports = class Place extends Model
  kind: 'place'

  defaults:
    lat: null
    lng: null
    loc_id: null
    address: null
    phone: null
    name: null
    intro: null
    headimg: null
    channels: []

  url: ->
    if @id
      "#{@apiRoot}/medias/#{@get 'media_id'}/places/#{@id}?include=channels,props"
    else
      "#{@apiRoot}/medias/#{@get 'media_id'}/places"

  pageUrl: ->
    "#{PAGE_ROOT}/place/#{@id}"

  inChina: ->
    loc_id = @get 'loc_id'
    loc_id >= 100000

  serialize: ->
    ret = super
    ret.inChina = @inChina()
    ret
