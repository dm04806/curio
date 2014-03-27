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
  submit: (e) ->
    super
    node = @$el
    node.addClass('loading')
    form = $(e.target)
    if form[0].remember.checked
      utils.store 'last_login', form[0].username.value
    else
      utils.store 'last_login', null
    $.post(e.target.action, form.serialize())
    .always =>
      node.removeClass('loading')
      setTimeout =>
        @enable()
      , 500
    .done (res) =>
      user = res?.user
      if user
        #@msg('login.success', 'success')
        mediator.execute 'login', res
        @publishEvent 'auth:login'
      else
        @msg("api_error.#{res?.error or 'general'}")
    .fail (res) =>
      # show as server error
      mediator.execute 'ajax-error', res, (err) =>
        err = err.code or err
        @msg("error.#{err}")
