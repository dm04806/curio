CollectionView = require './collection'
CollectionItemView = require './collection_item'
View = require './view'

module.exports = class ListableView extends View
  autoRender: false
  className: 'main-container'
  optionNames: View::optionNames.concat ['itemView', 'params']
  params: null
  itemView: null
  itemTemplate: null
  collectionView: CollectionView
  collectionTemplate: null

  listableSelector: '.list-container'
  context: ->
    fallback:
      title: 'error.noresult'

  getItemView: ->
    view = @itemView or @collectionView::itemView
    if not view
      itemTemplate = @itemTemplate
      view = @itemView = class MyItemView extends CollectionItemView
        template: itemTemplate
    return view

  initialize: ->
    super
    collection = @collection
    if not collection
      if @_collection
        collection = new @_collection [], params: @params
      else
        collection = @_model.collection [], params: @params
      @collection = collection
    if not @autoRender
      # if not autoRender,
      # will still render after a auto fetch
      collection.fetch().done =>
        @render()

  getViewForItem: (item) ->
    @subview('listable').getViewForItem(item)

  render: ->
    super
    collection = @collection
    collection.fetch() if not collection.length
    listable = new @collectionView
      container: @$el.find(@listableSelector)
      itemView: @getItemView()
      context: @context
      collection: collection
    listable.route = @route # pass on route information
    @subview 'listable', listable

