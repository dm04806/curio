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
      if res.user
        @msg('login.success', 'success')
        @publishEvent('login:success', res.user)
      else
        @msg("error.#{res.error or 'general'}")
    .fail (res) =>
      # show as server error
      @msg('error.connection')
  msg: (text, type='danger') ->
    @$el.find('.form-message')
      .attr('class', "form-message alert alert-#{type}")
      .html(__(text))
  events:
    'submit .login-form': 'login'
