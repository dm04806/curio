Controller = require 'controllers/base/controller'

SingledPageView = require 'views/base/singled'

LoginMain = require 'views/account/login'

module.exports = class LoginController extends Controller
  siteView: SingledPageView
  needPermit: null
  index: ->
    @view = new LoginMain region: 'main'
