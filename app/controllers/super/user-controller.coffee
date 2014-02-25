SuperHome = require './home-controller'
UserIndexView = require 'views/super/user-view'
UserShow = require 'views/super/user-view/show'
User = require 'models/user'

module.exports = class UserHome extends SuperHome
  route: 'super/user'
  MainViews:
    index: UserIndexView
    show: UserShow
    create: UserShow
  Model: User
