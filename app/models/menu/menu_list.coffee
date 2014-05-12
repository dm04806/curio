Collection = require 'models/base/collection'

MenuCell = require './menu_cell'

module.exports = class MenuList extends Collection
  model: MenuCell
  nextOrder: ->
    #下一个
    if not @length
      return 1

    return @last().get("order") + 1
  swapIndexs:(index1,index2) ->
    #交换两个item的位置
    models1 = @where index:index1
    models2 = @where index:index2

    #alert("sort indexs:"+index1+","+models1+","+index2+","+models2);

    if models1.length>0 and models2.length>0
      models1[0].set index:index2
      models2[0].set index:index1
      @sort()
  resetIndexs: ->
    #重置索引位置
    _.each @models,(model,index,context) ->
      model.set index:index
  comparator: "index"