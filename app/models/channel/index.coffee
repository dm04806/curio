Model = require 'models/base/model'

module.exports = class Channel extends Model
  kind: 'channel'

  # 二维码图片地址
  qrcodeUrl: ->
    return '' if not @get 'ticket'
    "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=" +
    encodeURIComponent(@get 'ticket')

  # 输出
  serialize: ->
    attrs = _.clone(this.attributes)
    attrs.qrcode_url = @qrcodeUrl()
    attrs
