View = require 'views/base/view'
mediator = require 'mediator'


module.exports = class SubscriberItem extends View
  template: require './templates/row'
  tagName: 'tr'
  className: ->
    cls = ''
    cls += ' unsubscribed' if not @model.get('subscribe')
    cls += ' actived' if @model.recentlyActived()
    cls

