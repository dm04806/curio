ListableView = require 'views/base/listable'
Media = require 'models/media'

module.exports = class SuperMediaView extends ListableView
  _model: Media
  template: require './templates/media_index'
  context:
    thead: require './templates/media_thead'
  itemView: require './media_row'
