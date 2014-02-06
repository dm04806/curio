ListableView = require 'views/base/listable'
Media = require 'models/media'

module.exports = class SuperMediaView extends ListableView
  collection: ->
    return Media.list()
  itemView: require './item'

