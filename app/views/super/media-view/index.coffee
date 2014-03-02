mediator = require 'mediator'
utils = require 'lib/utils'
ModalView = require 'views/common/modal'
ListableView = require 'views/base/listable'
MediaCollection = require 'models/media/collection'
AssignAdmin = require './assign_admin'


class DeleteItemModal extends ModalView
  template: require './templates/delete_item_modal'
  confirmed: ->
    model = @model
    model.destroy().done ->
      model.dispose()
  events:
    'click .btn-confirm': 'confirmed'

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

  deleteItem: (e) ->
    model = @collection.get @_getId(e.target)
    view = new DeleteItemModal model: model

  events:
    'click .to-admin': 'setPanelMedia'
    'click .to-delete': 'deleteItem'
    'click .admins a': 'assignAdmin'
