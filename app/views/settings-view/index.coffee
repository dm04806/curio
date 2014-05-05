mediator = require 'mediator'
EditFormView = require 'views/common/edit_form'

module.exports = class HomeMain extends EditFormView
  template: require './templates/index'
  context: ->
    media: mediator.media.attributes

  updateWebotUrl: (e) ->
    uid = e.target.value
    @$el.find('#webot-url').val(@model.webotUrl(uid))

  events:
    'input input[name=uid]': 'updateWebotUrl'

