CollectionView = require 'views/base/collection'
View = require './view'

module.exports = class ListableView extends View
  autoRender: true
  className: 'main-container'
  optionNames: View::optionNames.concat ['itemView', 'params']
  params: null
  itemView: null
  collectionView: CollectionView
  #pagerView: PagerView
  regions:
    'listable': '#listable'
  context: ->
    fallback:
      title: 'error.noresult'
  render: ->
    super
    collection = @collection
    if not collection
      if @_collection
        collection = new @_collection [], params: @params
      else
        collection = @_model.all @params
      @collection = collection
    collection.fetch() if not collection.length
    listable = new @collectionView
      region: 'listable'
      itemView: @itemView or @collectionView::itemView
      context: @context
      collection: collection
    @subview 'listable', listable
    #@subview 'pager', pager
