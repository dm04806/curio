View = require 'views/base/view'

module.exports = class MediaRowView extends View
  tagName: 'tr'
  template: require './templates/media_row'
