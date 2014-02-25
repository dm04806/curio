mediator = require 'mediator'
utils = require 'lib/utils'
ListableView = require 'views/base/listable'
MediaCollection = require 'models/media/collection'
AssignAdmin = require './assign_admin'


module.exports = class MediaIndexView extends ListableView
  _collection: MediaCollection
  template: require './templates/index'
  context:
    thead: require './templates/thead'
  itemView: require './row'

  _getId: (elem) ->
    $(elem).closest('tr').data('id')

  setPanelMedia: (e) ->
    # save as all media admins
    @collection.asAdmins()
    mediator.execute 'toggle-media', @_getId(e.target)

  assignAdmin: (e) ->
    @assign_admin = new AssignAdmin
      model: @collection.get @_getId(e.target)
    e.preventDefault()
    e.stopPropagation()

  dispose: ->
    super
    # clear the user list cache
    @assign_admin?.clear()

  events:
    'click .to-admin': 'setPanelMedia'
    'click .admins a': 'assignAdmin'
