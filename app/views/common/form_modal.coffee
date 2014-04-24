ModalView = require './modal'
FormView = require './form'
common = require './utils'

module.exports = class FormModalView extends FormView
  # Also inherit from ModalView
  _.extend @prototype, ModalView.prototype

  render: ->
    super
    ModalView::render.call(this)

  # display form message in modal
  msg: (text, type='danger', expires=2100) ->
    common.notify(text, type, expires, el: @$el.find('.noti'))

  listen:
    'submitted': ->
      # hide modal when form submitted
      @$el.delay(200).promise().done =>
        @$el.modal('hide')
    'confirm': ->
      # submit form when click on confirm button
      @$el.find('form').trigger('submit')

