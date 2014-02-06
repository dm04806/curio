Controller = require 'controllers/base/controller'
mediator = require 'mediator'
{store} = require 'lib/utils'

module.exports = class LogoutController extends Controller
  needPermit: null
  pageLayout: 'single'
  beforeAction: ->
    path = window.location.pathname
    if path != '/logout' and path != '/login'
      store 'login_return', location.href
    mediator.execute 'logout'
    @redirectTo url: '/login'
  index: (a, b, c) ->
    console.log a,b,c
