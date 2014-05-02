EditFormView = require 'views/common/edit_form'
Passport = require 'models/user/passport'
common = require 'views/common/utils'
utils = require 'lib/utils'

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

  toDestroy: (node) ->
    view = common.confirm 'delete.confirm'
    view.on 'confirm', =>
      @model.destroy().done ->
        view.close()
        utils.redirectTo 'super/user#index'
        common.notify 'delete.success'

  events:
    'click .modify-passwd': 'modifyPasswd'
