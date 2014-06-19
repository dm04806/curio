Collection = require 'models/base/collection'
Channel = require './index'

module.exports = class ChannelCollection extends Collection
  model: Channel

  parse: (res) ->
    ret = super
    @next_scene_id = res.next_scene_id
    return ret

