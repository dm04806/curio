View = require 'views/base/view'

module.exports = class MediaItemView extends View
  tagName: 'tr'
  template: require './templates/row'
