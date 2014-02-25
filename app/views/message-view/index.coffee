mediator = require 'mediator'
utils = require 'lib/utils'
ListableView = require 'views/base/listable'
MessageListView = require './list'

module.exports = class MediaIndexView extends ListableView
  template: require './templates/index'
  regions:
    'listable': '.messages'
  collectionView: MessageListView
