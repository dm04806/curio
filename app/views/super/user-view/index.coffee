ListableView = require 'views/base/listable'
User = require 'models/user'

module.exports = class UserIndexView extends ListableView
  _model: User
  template: require './templates/index'
  context:
    thead: require './templates/thead'
  itemTemplate: require './templates/row'
