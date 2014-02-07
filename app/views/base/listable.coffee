CollectionView = require 'views/base/collection'
View = require './view'

module.exports = class ListableView extends View
  autoRender: true
  className: 'main-container'
  optionNames: View::optionNames.concat ['itemView', 'params']
  collectionView: CollectionView
  #pagerView: PagerView
  regions:
    'listable': '#listable'
  context: ->
    fallback:
      title: 'error.noresult'
  render: ->
    super
    collection = @_model.all @params
    listable = new @collectionView
      region: 'listable'
      itemView: @itemView
      context: @context
      collection: collection
    @subview 'listable', listable
    #@subview 'pager', pager
    collection.fetch()
