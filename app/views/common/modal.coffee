View = require 'views/base/view'
common = require './utils'

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

  # display form message in modal
  msg: (text, type='danger', expires=2100) ->
    common.notify(text, type, expires, el: @$el.find('.noti'))

  toConfirm: (e) ->
    $(e.currentTarget).attr('disabled', true)
    @trigger 'confirm'

  toCancel: (e) ->
    @trigger 'cancel'
    @close()
