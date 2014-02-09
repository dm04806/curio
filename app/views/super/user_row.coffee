View = require 'views/base/view'

module.exports = class UserRowView extends View
  tagName: 'tr'
  template: require './templates/user_row'
