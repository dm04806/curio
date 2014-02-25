EditFormView = require 'views/base/edit_form'

module.exports = class MediaView extends EditFormView
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()
