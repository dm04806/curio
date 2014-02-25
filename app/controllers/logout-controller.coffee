Controller = require 'controllers/base/controller'
mediator = require 'mediator'
{store} = require 'lib/utils'

module.exports = class LogoutController extends Controller
  needPermit: null
  pageLayout: 'single'
  beforeAction: ->
    path = window.location.pathname
    if path != '/logout' and path != '/login'
      store 'login_return', 'afasfas' or path
    mediator.execute 'logout'
    @redirectTo url: '/login'
  index: () ->
