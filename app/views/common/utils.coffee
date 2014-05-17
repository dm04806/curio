Modal = require './modal'
utils = require 'lib/utils'

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

exports.confirm = (opts, callback) ->
  opts.view = ConfirmModal
  if 'string' == typeof opts
    opts =
      message: opts
      view: ConfirmModal
  view = exports.alert(opts)
  if callback
    view.on 'confirm', ->
      view.close()
      callback()
  view


exports.notify = (message, category, duration=1600, opts={}) ->
  return if not message
  message += ''
  if 'number' is typeof category
    duration = category
    category = undefined
  if not category
    category = if message.indexOf('success') >= 1 then 'success' else 'danger'
  if _.isPlainObject(message)
    opts = message
  else
    opts.message = message
    opts.duration = duration
    opts.category = category
  _.defaults opts,
    el: '#global-noti'
    fading: 'fadeOutUp'
    category: 'danger'
  content = """
    <div class="alert alert-#{opts.category}">
      #{__(opts.message)}
    </div>
  """
  ret = $(opts.el).html(content)
    .stop(true)
    .css('display', 'block')
    .anim('fadeInDown', 200)
    .delay(opts.duration)
    .anim(opts.fading, 600)
  ret.promise().done ->
    ret.css('display', 'none')
  ret

exports.xhrError = (xhr, prefix) ->
  err = utils.xhrError xhr
  err = (prefix or '') + err.code
  exports.notify err
