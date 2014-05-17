Collection = require 'models/base/collection'
Button = require './button'

module.exports = class MenuButtonCollection extends Collection
  model: Button

  initialize: (items, options) ->
    super
    @parent = parent if options.parent

  # create new
  append: ->
    # 如果没有父级菜单，则添加主菜单项

  comparator: "index"
