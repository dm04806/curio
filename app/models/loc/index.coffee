Model = require 'models/base/model'
Channel = require 'models/channel'

module.exports = class Loc extends Model
  kind: 'loc'

  defaults:
    name: null
    level: null
    children: []

  level_cn: ->
    __ "loc.#{@attributes.level}"

  ##
  # 是否为中国境内(TODO: 用更靠谱的判断)
  #
  inChina: ->
    100000 <= @id <= 820000

  serialize: ->
    ret = @toJSON()
    ret.level_cn = @level_cn()
    ret
