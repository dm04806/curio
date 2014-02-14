Collection = require 'models/base/collection'
Media = require './index'
mediator = require 'mediator'
utils =  require 'lib/utils'

session = require 'models/session'

module.exports = class MediaCollection extends Collection
  model: Media
  # save to localStorage as admin selections
  asAdmins: ->
    session.allAdmins @map (item) ->
      role: null,
      media_id: item.id
      media: item.attributes
