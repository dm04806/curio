FormModalView = require './form_modal'
EditFormView = require './edit_form'

module.exports = class EditFormModal extends FormModalView
  _.extend @prototype, EditFormView.prototype
