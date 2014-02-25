View = require 'views/base/view'
User = require 'models/user'

class AssignAdmin extends View
  autoRender: true
  noWrap: true
  template: require './templates/assign_admin_modal'
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
  template: require './templates/row'
  assign: (e) ->
    view = new AssignAdmin model: @model, container: 'body'
    return unless e
    e.preventDefault()
    e.stopPropagation()
  events:
    'click .admins a': 'assign'
