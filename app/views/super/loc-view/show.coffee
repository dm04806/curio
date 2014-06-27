EditFormView = require 'views/common/edit_form'
common = require 'views/common/utils'
utils = require 'lib/utils'

module.exports = class LocView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

  toDestroy: (node) ->
    view = common.confirm 'delete.confirm'
    view.on 'confirm', =>
      @model.destroy().done ->
        view.close()
        utils.redirectTo 'super/loc#index'
        common.notify 'delete.success'

