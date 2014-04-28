mediator = require 'mediator'
utils = require 'lib/utils'
ModalView = require 'views/common/modal'
CollectionView = require 'views/base/collection'
CreateView = require './create'

module.exports = class ChannelIndexView extends CollectionView
  className: 'main-container'
  itemView: require './row'
  template: require './templates/index'
  animationDuration: 500
  context: ->
    total: @collection.total

  render: ->
    super
    #@toCreate()

  # Create a channel
  toCreate: ->
    view = new CreateView
    view.on 'submitted', (items) =>
      # when modal is fully closed
      view.on 'dispose', =>
        items.forEach (item) =>
          if @collection.length
            @collection.add item, {at: 0}
          else
            location.reload()

  checkEmpty: ->
    if not @collection.length
      location.reload()

  listen:
    'remove collection': 'checkEmpty'
