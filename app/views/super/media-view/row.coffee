ModalView = require 'views/common/modal'
ItemView = require 'views/base/collection_item'
User = require 'models/user'
common = require 'views/common/utils'

BG_MODIFIED = '#fefee9'


class DeleteItemModal extends ModalView
  template: require './templates/delete_item_modal'

  toConfirm: ->
    model = @model
    @$el.modal('hide')
    @trigger 'confirmed'


module.exports = class MediaRowView extends ItemView
  template: require './templates/row'
  updateAdmins: ->
    @render() # rerender item
    # give an animation to get the user's attention
    node = @$el.children()
    color = node.css('backgroundColor')
    node.css('backgroundColor', BG_MODIFIED)
      .delay(1000)
      .animate({
        backgroundColor: color
      }, 600)
  toDestroy: (node) ->
    view = common.confirm {
      message: __('medias.delete.confirm', @model.get 'name')
      detail:  'medias.delete.consequece'
    }, =>
      @$el.fadeOut()
      setTimeout =>
        @model.destroy().done ->
          common.notify 'delete.success'
      , 200

  listen:
    'change model': 'updateAdmins'
