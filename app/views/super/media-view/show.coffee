EditFormView = require 'views/common/edit_form'

module.exports = class MediaView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    edit_media: require './templates/edit_media'
    isNew: @model.isNew()
    back_url: '/super/medias'
