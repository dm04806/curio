Model = require 'models/base/model'
Subscriber = require 'models/subscriber'


EVENT_TYPES = ['subscribe', 'unsubscribe', 'click']

module.exports = class Message extends Model
  kind: 'message'

  initialize: ->
    super
    if @is('text') and 'string' != typeof @get('content')
      # make sure text message displays as text
      @set 'content', JSON.stringify(@get('content'))

  is: (type) ->
    @get('content_type') == type

  isEventMsg: () ->
    @get('content_type') in EVENT_TYPES

  # describe event in a line of sencence
  eventLine: () ->
    switch @get 'content_type'
      when 'subscribe' then __ 'message.subscribed'
      when 'unsubscribe' then __ 'message.unsubscribed'
      when 'click' then __ 'message.click', @get('content').eventKey
      when 'scan' then __ 'message.scan', @get('content').scene_id

  serialize: ->
    ret = @toJSON()
    if ret.subscriber instanceof Subscriber
      ret.subscriber = ret.subscriber.serialize()
    ret
