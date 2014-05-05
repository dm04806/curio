Model = require 'models/base/model'

module.exports = class Channel extends Model
  kind: 'channel'
  defaults:
    desc: null
    name: null
    scene_id: null

  url: ->
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
