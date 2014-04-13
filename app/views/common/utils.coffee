Modal = require './modal'

class AlertModal extends Modal
  template: require './templates/alert_modal'
  context: ->
    cancel_button_class: 'btn-primary'
    cancel_button: __('alert.ok')


class ConfirmModal extends Modal
  template: require './templates/alert_modal'
  context: ->
    confirm_button_class: 'btn-danger'
    cancel_button_class: 'btn-default'
    confirm_button: __('confirm')
    cancel_button: __('cancel')


exports.alert = (message, detail, opts={}) ->
  if opts.translate isnt false
    message = __(message)
    detail = __(detail)
    delete opts.translsate
    for k of opts
      opts[k] = __(opts[k])
  opts.message = message
  opts.detail = detail
  View = opts.view or AlertModal
  new View data: opts

exports.confirm = (message, detail, opts={}) ->
  opts.view = ConfirmModal
  exports.alert(message, detail, opts)
