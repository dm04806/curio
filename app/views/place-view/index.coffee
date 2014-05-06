mediator = require 'mediator'
utils = require 'lib/utils'
ModalView = require 'views/common/modal'
CollectionView = require 'views/base/collection'

module.exports = class PlaceIndexView extends CollectionView
  className: 'main-container'
  itemView: require './row'
  template: require './templates/index'
  animationDuration: 500
  context: ->
    total: @collection.total

  render: ->
    super
    #@toCreate()

  checkEmpty: ->
    if not @collection.length
      location.reload()

  listen:
    'remove collection': 'checkEmpty'
