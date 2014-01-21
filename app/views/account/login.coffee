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
        @loginSuccess(res.user)
        @showMessage('login.success', 'success')
      else
        @showMessage("error.#{res.error or 'general'}")
    .fail (res) =>
      # show as server error
      @showMessage('error.connection')
  loginSuccess: (user) ->
    mediator.publish('auth:login', user)
  showMessage: (text, type='danger') ->
    @$el.find('.form-message')
      .attr('class', "form-message alert alert-#{type}")
      .html(__(text))
  events:
    'submit .login-form': 'login'
