Model = require 'models/base/model'
mediator = require 'mediator'

module.exports = class Channel extends Model
  kind: 'channel'
  defaults:
    desc: null
    name: null
    scene_id: null

  @findOrCreate: (scene_id) ->
    url = @urlRoot()
    $.post url, { scene_id: scene_id }

  @urlRoot: ->
    "#{mediator.media.url()}/channels"

  url: (params) ->
    console.log arguments
    "#{@apiRoot}/medias/#{@get 'media_id'}/channels/#{@id}"

  # 二维码图片地址
  qrcodeUrl: ->
    return '' if not @get 'ticket'
    "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" +
    encodeURIComponent(@get 'ticket')

  # 输出给模版
  serialize: ->
    attrs = @toJSON()
    attrs.qrcode_url = @qrcodeUrl()
    attrs
