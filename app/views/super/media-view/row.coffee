ItemView = require 'views/base/collection_item'
User = require 'models/user'

module.exports = class MediaRowView extends ItemView
  template: require './templates/row'
  listen:
    'change model': 'render'
