View = require 'views/base/view'

##
# A auto shown modal
#
# Usage:
#
#   1. Assign custom template
#   2. Add a 'button[data-op="toConfirm"]'
#   3. listenTo 'confirm' event
#
module.exports = class ModalView extends View
  autoRender: true
  noWrap: true
  region: null
  container: 'body'
  render: ->
    super
    @$el.on 'show.bs.modal', ->
      $(document.body).addClass('modal-open')
    .on 'hidden.bs.modal', =>
      $(document.body).removeClass('modal-open')
      # dispose view when modal closed
      @dispose()
    @$el.modal()

  close: () ->
    @$el.modal('hide')

  toConfirm: (e) ->
    $(e.currentTarget).attr('disabled', true)
    @trigger 'confirm'

  toCancel: (e) ->
    @trigger 'cancel'
    @close()
