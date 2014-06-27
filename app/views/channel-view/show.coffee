EditFormView = require 'views/common/edit_form'
ReplyView = require 'views/rules-view/reply'
mediator = require 'mediator'
Rule = require 'models/responder/rule'

module.exports = class ChannelView extends EditFormView
  className: 'main-container'
  template: require './templates/show'
  context: ->
    isNew: @model.isNew()

  render: ->
    super
    #subRule = Rule.create('$unsubscribed_scan')
    #scanRule = Rule.create('$subscribed_scan')
    #view1 = new ReplyView model: subRule, el: @$('#subscribe-reply')
    #view2 = new ReplyView model: scanRule, el: @$('#scan-reply')
    #@subview 'subscribe-reply', view1
    #@subview 'scan-reply', view2

