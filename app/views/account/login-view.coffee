FormView = require 'views/common/form'
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

  _submit: (e) ->
    form = e.target
    if form.remember.checked
      utils.store 'last_login', form.username.value
    else
      utils.store 'last_login', null
    super

  _submitDone: (res) ->
    user = res?.user
    if user
      #@msg('login.success', 'success')
      mediator.execute 'login', res
      @publishEvent 'auth:login'
    else
      @msg("error.#{res?.error or 'general'}")
