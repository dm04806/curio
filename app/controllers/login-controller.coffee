Controller = require 'controllers/base/controller'
{store} = require 'lib/utils'

module.exports = class LoginController extends Controller
  needPermit: null
  pageLayout: 'single'
  main: require 'views/account/login'
  index: ->
    super
    @subscribeEvent 'login:success', =>
      redir = store 'login_return' or '/'
      @redirectTo { url: redir }

