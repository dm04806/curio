Model = require 'models/base/model'

module.exports = class Place extends Model
  kind: 'place'
  defaults:
    lat: null
    lng: null
  url: ->
    "#{@apiRoot}/medias/#{@get 'media_id'}/places/#{@id}"
