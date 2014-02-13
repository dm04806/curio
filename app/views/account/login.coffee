FormView = require 'views/base/form'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class LoginMain extends FormView
  template: require './templates/login'
  className: 'login-container'
  render: ->
    super
    last_login = utils.store 'last_login'
    if last_login
      @$el.find('[name=username]').val last_login
  msg: (text, type='danger') ->
    alerted = @$el.find('.alert').length
    msg = super
    if type == 'danger' and alerted
      msg.anim('shake')
  submit: (e) ->
    e.preventDefault()
    node = @$el
    node.addClass('loading')
    form = $(e.target)
    if form[0].remember.checked
      utils.store 'last_login', form[0].username.value
    else
      utils.store 'last_login', null
    $.post(e.target.action, form.serialize())
    .always ->
      node.removeClass('loading')
    .done (res) =>
      user = res?.user
      if user
        @msg('login.success', 'success')
        mediator.execute 'login', res
        @publishEvent 'auth:login'
      else
        @msg("error.#{res?.error or 'general'}")
    .fail (res) =>
      # show as server error
      @msg('error.connection')
