EditFormView = require 'views/base/edit_form'

ModifyPasswd = require './modify_passwd'

module.exports = class UserView extends EditFormView
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

  modifyPasswd: (e) ->
    e.preventDefault()
    e.stopPropagation()
    new ModifyPasswd model: @model

  events:
    'click .modify-passwd': 'modifyPasswd'
