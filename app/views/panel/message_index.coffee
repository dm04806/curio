mediator = require 'mediator'
utils = require 'lib/utils'
ListableView = require 'views/base/listable'
MessageListView = require './message_list'

module.exports = class MediaIndexView extends ListableView
  template: require './templates/message_index'
  regions:
    'listable': '.messages'
  collectionView: MessageListView
