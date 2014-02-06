CollectionView = require 'views/base/collection'

module.exports = class ListableView extends CollectionView
  autoRender: true
  template: require './templates/listable'
  listSelector: '.listable'
  loadingSelector: '.collection-indicator'
  fallbackSelector: '.collection-fallback'
