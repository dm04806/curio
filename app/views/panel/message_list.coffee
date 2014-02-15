CollectionView = require 'views/base/collection'
MessageItemView = require './message_item'

module.exports = class MessageListView extends CollectionView
  itemView: MessageItemView
  template: require './templates/message_list'
