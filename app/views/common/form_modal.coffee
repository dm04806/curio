ModalView = require './modal'
FormView = require '../base/form'

module.exports = class FormModalView extends FormView
  _.extend @prototype, ModalView.prototype
  render: ->
    super
    ModalView::render.call(this)