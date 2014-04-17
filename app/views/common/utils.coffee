Modal = require './modal'

class AlertModal extends Modal
  template: require './templates/alert_modal'
  initialize: ->
    super
  context: ->
    modal_class: 'modal alert-modal'
    cancel_button_class: 'btn-primary'
    cancel_button: __('got it')


class ConfirmModal extends AlertModal
  initialize: ->
    super
  context: ->
    modal_class: 'modal alert-modal'
    confirm_button_class: 'btn-danger'
    confirm_button: __('confirm')
    cancel_button_class: 'btn-default'
    cancel_button: __('cancel')


exports.alert = (message, detail, opts={}) ->
  if _.isPlainObject(message)
    opts = message
  else
    opts.message = message
    opts.detail = detail

  if opts.translate isnt false
    delete opts.translsate
    for k of opts
      opts[k] = __(opts[k])

  View = opts.view or AlertModal
  new View data: opts

exports.confirm = (message, detail, opts={}) ->
  opts.view = ConfirmModal
  exports.alert(message, detail, opts)


exports.notify = (message, category, duration=1600, opts={}) ->
  if 'number' is typeof category
    duration = category
    category = null
  if _.isPlainObject(message)
    opts = message
  else
    opts.message = message
    opts.duration = duration
    opts.category = category
  _.defaults opts,
    fading: 'fadeOutUp'
    category: 'warning'
  content = """
    <div class="alert alert-#{opts.category}">
      #{__(opts.message)}
    </div>
  """
  ret = $('#global-noti').html(content)
    .show()
    .find('.alert')
    .delay(opts.duration)
    .anim(opts.fading)
  ret
