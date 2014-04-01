EditFormView = require 'views/base/edit_form'

module.exports = class MediaView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    edit_media: require './templates/edit_media'
    isNew: @model.isNew()
