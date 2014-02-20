View = require './view'

module.exports = class CollectionView extends Chaplin.CollectionView
  # This class doesn’t inherit from the application-specific View class,
  # so we need to borrow the method from the View prototype:
  getTemplateFunction: View::getTemplateFunction
  getTemplateData: View::getTemplateData

  optionNames: CollectionView::optionNames.concat ['context']

  template: require './templates/listable'
  className: 'listable'

  listSelector: '.list'
  loadingSelector: 'div.placeholder'
  fallbackSelector: 'div.fallback'
  useCssAnimation: true

  push: (item) ->
    @collection.push item

  # Show spinner only for >0.3s queries.
  toggleLoadingIndicator: ->
    unless @collection.length is 0 and @collection.isSyncing()
      super
      return
    setTimeout =>
      if @collection
        super
    , 300
