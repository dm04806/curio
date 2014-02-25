Controller = require 'controllers/base/controller'
{store} = require 'lib/utils'
mediator = require 'mediator'

module.exports = class LoginController extends Controller
  needPermit: null
  pageLayout: 'single'
  main: require 'views/account/login-view'
  isRedirectable: (url) ->
    return not /\/(login|logout)/i.test(url)
  index: ->
    super
    @subscribeEvent 'auth:login', =>
      redir = store 'redirecting'
      if not redir
        redir = (store 'login_return') or '/'
        redir = '/' if not @isRedirectable(redir)
        redir = { url: redir }
      @redirectTo redir

