View = require 'views/base/view'

##
# A auto shown modal
#
module.exports = class ModalView extends View
  autoRender: true
  noWrap: true
  container: 'body'
  render: ->
    #origin = @model
    #if origin
      #clone = origin.clone()
      #clone.on 'change', (item) ->
        #origin.set item.attributes
      #@model = clone
    super
    @$el.on 'show.bs.modal', ->
      $(document.body).addClass('modal-open')
    .on 'hidden.bs.modal', '.modal', =>
      $(document.body).removeClass('modal-open')
      # dispose view when modal closed
      @dispose()
    @$el.modal()
