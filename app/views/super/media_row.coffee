View = require 'views/base/view'
User = require 'models/user'

class AssignAdmin extends View
  autoRender: true
  className: 'modal fade'
  template: require './templates/media/assign_admin'
  render: ->
    super
   # show the modal when rendered
    @$el.modal()
    .on 'hidden.bs.modal', =>
      items = @$el.find('li')
      # dispose when modal closed
      @dispose()


module.exports = class MediaRowView extends View
  tagName: 'tr'
  template: require './templates/media_row'
  assign: (e) ->
    view = new AssignAdmin model: @model, container: @el
    return unless e
    e.preventDefault()
    e.stopPropagation()
  events:
    'click .admins a': 'assign'
