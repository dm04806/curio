Collection = require 'models/base/collection'
Media = require './index'
mediator = require 'mediator'
utils =  require 'lib/utils'

module.exports = class MediaCollection extends Collection
  model: Media
  # save to localStorage as admin selections
  asAdmins: ->
    {SK_ALL_MEDIA_ADMINS} = require 'controllers/base/session'
    utils.store SK_ALL_MEDIA_ADMINS, @map (item) ->
      role: null,
      media_id: item.id
      media: item.attributes
