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

  serialize: ->
    ret = @toJSON()
    ret.level_cn = @level_cn()
    ret
