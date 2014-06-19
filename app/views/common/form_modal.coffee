ModalView = require './modal'
FormView = require './form'

module.exports = class FormModalView extends FormView
  # Also inherit from ModalView
  _.extend @prototype, ModalView.prototype

  render: ->
    super
    ModalView::render.call(this)

  listen:
    'submitted': ->
      # hide modal when form submitted
      @$el.delay(200).promise().done =>
        @$el.modal('hide')
    'confirm': ->
      # submit form when click on confirm button
      @$el.find('form').trigger('submit')

