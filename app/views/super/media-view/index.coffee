mediator = require 'mediator'
utils = require 'lib/utils'
ListableView = require 'views/base/listable'
MediaCollection = require 'models/media/collection'

module.exports = class MediaIndexView extends ListableView
  _collection: MediaCollection
  template: require './templates/index'
  context:
    thead: require './templates/thead'
  itemView: require './row'
  setPanelMedia: (e) ->
    # save as all media admins
    @collection.asAdmins()
    mediator.execute 'toggle-media', $(e.currentTarget).data('media')
  events:
    'click .to-admin': 'setPanelMedia'
