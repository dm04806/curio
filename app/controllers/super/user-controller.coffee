SuperHome = require './home-controller'
UserIndexView = require 'views/super/user-view'
UserShow = require 'views/super/user-view/show'
User = require 'models/user'

module.exports = class UserHome extends SuperHome
  MainViews:
    index: UserIndexView
    show: UserShow
    create: UserShow
  Model: User
