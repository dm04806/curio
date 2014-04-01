CollectionView = require 'views/base/collection'
MessageItemView = require './item'

module.exports = class MessageListView extends CollectionView
  itemView: MessageItemView
  listSelector: '.media-list'
  template: require './templates/list'
