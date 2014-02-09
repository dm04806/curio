View = require 'views/base'
mediator = require 'mediator'

module.exports = class LoginMain extends View
  autoRender: true
  template: require './templates/login'
  login: (e) ->
    e.preventDefault()
    node = @$el
    node.addClass('loading')
    form = $(e.target)
    $.post(e.target.action, form.serialize())
    .always ->
      node.removeClass('loading')
    .done (res) =>
      user = res?.user
      if user
        @msg('login.success', 'success')
        mediator.execute('login', res)
        @publishEvent('auth:login')
      else
        @msg("error.#{res?.error or 'general'}")
    .fail (res) =>
      # show as server error
      @msg('error.connection')
  msg: (text, type='danger') ->
    msg = @$el.find('.form-message')
      .attr('class', "form-message alert alert-#{type}")
      .html(__(text))
    if type is 'danger'
      msg.anim('shake')
  events:
    'submit .login-form': 'login'
