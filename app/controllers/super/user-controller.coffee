SuperHome = require './home-controller'
UserIndexView = require 'views/super/user_index'
UserShow = require 'views/super/user_show'
User = require 'models/user'

module.exports = class UserHome extends SuperHome
  index: (params, route, options) ->
    @view = new UserIndexView region: 'main', params: params
  show: (params) ->
    model = new User({ id: params.id })
    model.fetch().then =>
      @view = new UserShow region: 'main', model: model
