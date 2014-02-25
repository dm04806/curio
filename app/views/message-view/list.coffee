CollectionView = require 'views/base/collection'
MessageItemView = require './item'

module.exports = class MessageListView extends CollectionView
  itemView: MessageItemView
  template: require './templates/list'
