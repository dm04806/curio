EditFormView = require 'views/base/edit_form'

module.exports = class UserView extends EditFormView
  template: require './templates/user_show'
  context: ->
    isNew: @model.isNew()
