EditFormView = require 'views/common/edit_form'

module.exports = class ChannelView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

