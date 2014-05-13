Model = require 'models/base/model'

module.exports = class Place extends Model
  kind: 'place'
  defaults:
    lat: null
    lng: null
    address: null
    phone: null
    name: null
    intro: null
  url: ->
    if @id
      "#{@apiRoot}/medias/#{@get 'media_id'}/places/#{@id}"
    else
      "#{@apiRoot}/medias/#{@get 'media_id'}/places"
