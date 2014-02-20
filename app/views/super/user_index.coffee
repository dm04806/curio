ListableView = require 'views/base/listable'
User = require 'models/user'

module.exports = class UserIndexView extends ListableView
  _model: User
  template: require './templates/user_index'
  context:
    thead: require './templates/user_thead'
  itemTemplate: require './templates/user_row'
