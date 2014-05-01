View = require 'views/base/view'
mediator = require 'mediator'


module.exports = class SubscriberItem extends View
  template: require './templates/row'
  tagName: 'tr'
  className: ->
    'unsubscribed' if not @model.get('subscribe')

