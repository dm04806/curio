EditFormView = require 'views/base/edit_form'
Passport = require 'models/user/passport'

ModifyPasswd = require './modify_passwd'

module.exports = class UserView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

  modifyPasswd: (e) ->
    e.preventDefault()
    e.stopPropagation()
    user = @model
    model = new Passport
      id: user.id
      name: user.get 'name'
    new ModifyPasswd model: model

  events:
    'click .modify-passwd': 'modifyPasswd'
