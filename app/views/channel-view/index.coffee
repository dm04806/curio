mediator = require 'mediator'
utils = require 'lib/utils'
ModalView = require 'views/common/modal'
CollectionView = require 'views/base/collection'
CreateView = require './create'

module.exports = class ChannelIndexView extends CollectionView
  className: 'main-container'
  itemView: require './row'
  template: require './templates/index'
  context: ->
    total: @collection.total

  render: ->
    super
    #@toCreate()

  # Create a channel
  toCreate: ->
    view = new CreateView


