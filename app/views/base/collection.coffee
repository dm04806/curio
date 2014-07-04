View = require './view'
PaginatorView = require 'views/widgets/paginator'
CollectionItemView = require './collection_item'

module.exports = class CollectionView extends Chaplin.CollectionView
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the method from the View prototype:
  getTemplateFunction: View::getTemplateFunction
  getTemplateData: View::getTemplateData
  adjustTitle: View::adjustTitle

  optionNames: CollectionView::optionNames.concat ['context']

  # default list is a table
  template: require './templates/listable'
  # default CollectionView as the main view
  className: 'main-container'

  listSelector: '.list'
  loadingSelector: 'div.placeholder'
  fallbackSelector: 'div.fallback'
  useCssAnimation: true
  animationDuration: 0
  animationStartClass: 'fade'
  animationEndClass: 'in'

  initialize: ->
    super
    View::initialize.apply(this, arguments)
    collection = @collection
    # get collection from constuctor class
    if not collection
      if @_collection
        collection = new @_collection [], params: @params
      else if @_model
        collection = @_model.collection [], params: @params
      if collection
        @collection = collection

  initItemView: (model) ->
    view = @itemView
    if not view
      itemTemplate = @itemTemplate
      view = @itemView = class MyItemView extends CollectionItemView
        template: itemTemplate
    new view model: model

  getViewForItem: (item) ->
    @subview "itemView:#{item.cid}"

  push: (item) ->
    @collection.push item

  # Show spinner only for >0.3s queries.
  toggleLoadingIndicator: ->
    return super if @collection.length isnt 0 or not @collection.isSyncing()
    setTimeout =>
      if @collection
        super
    , 300

  getPaginatorView: ->
    paginator = new PaginatorView
      route: @route
      container: @$list.closest('div')
      collection: @collection

  renderPaginator: ->
    if @collection.isSyncing() or not @collection.length
      return
    @subview 'paginator', @getPaginatorView()

  listen:
    'addedToDOM': ->
      @renderPaginator()
      @adjustTitle()
    'sync collection': 'renderPaginator'

  events: View::events

