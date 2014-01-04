View = require 'views/base'

module.exports = class LoginMain extends View
  autoRender: true
  template: require './templates/login'
  context:
    login_url: '/login'
