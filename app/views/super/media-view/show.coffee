EditFormView = require 'views/base/edit_form'

module.exports = class MediaView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()
