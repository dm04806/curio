Controller = require 'controllers/base/controller'

module.exports = class LoginController extends Controller
  needPermit: null
  pageLayout: 'single'
  main: require 'views/account/login'
