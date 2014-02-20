CollectionView = require 'views/base/collection'
View = require './view'

class ItemView extends View
  autoRender: true
  tagName: 'tr'

module.exports = class ListableView extends View
  autoRender: false
  className: 'main-container'
  optionNames: View::optionNames.concat ['itemView', 'params']
  params: null
  itemView: null
  itemTemplate: null
  collectionView: CollectionView
  collectionTemplate: null
  #pagerView: PagerView
  regions:
    'listable': '#listable'
  context: ->
    fallback:
      title: 'error.noresult'
  getItemView: ->
    view = @itemView or @collectionView::itemView
    if not view
      itemTemplate = @itemTemplate
      view = @itemView = class MyItemView extends ItemView
        template: itemTemplate
    return view
  initialize: ->
    super
    collection = @collection
    if not collection
      if @_collection
        collection = new @_collection [], params: @params
      else
        collection = @_model.all @params
      @collection = collection
    if not @autoRender
      collection.fetch().done =>
        @render()
  render: ->
    super
    collection = @collection
    collection.fetch() if not collection.length
    listable = new @collectionView
      region: 'listable'
      itemView: @getItemView()
      context: @context
      collection: collection
    @subview 'listable', listable
    #@subview 'pager', pager
