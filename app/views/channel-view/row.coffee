View = require 'views/base/view'
mediator = require 'mediator'
common = require 'views/common/utils'

module.exports = class ChannelRow extends View
  noWrap: true
  template: require './templates/row'

  toDestroy: (node) ->
    common.confirm 'delete.confirm', =>
      @model.destroy({ wait: true })
        .error(common.xhrError)
        .done(-> common.notify('delete.success', 1000))


