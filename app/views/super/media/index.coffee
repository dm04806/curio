ListableView = require 'views/base/listable'
Media = require 'models/media'

module.exports = class SuperMediaView extends ListableView
  _model: Media
  template: require './templates/index'
  context:
    thead: require './templates/thead'
  itemView: require './item'
