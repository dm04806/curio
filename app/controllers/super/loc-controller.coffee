SuperHome = require './home-controller'
LocIndexView = require 'views/super/loc-view'
LocShow = require 'views/super/loc-view/show'
Loc = require 'models/loc'

module.exports = class LocHome extends SuperHome
  MainViews:
    index: LocIndexView
    show: LocShow
    create: LocShow
  Model: Loc
  index: (params) ->
    params.include = 'parent'
    super

