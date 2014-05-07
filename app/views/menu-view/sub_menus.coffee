mediator = require 'mediator'
View = require 'views/base/view'
MenuCell = require 'models/menu/menu_cell'
SubMenuItem = require './sub_menu_item'

module.exports = class SubMenus extends View
  tagName: "div"
  template: require './templates/sub_menus'
  events:
    "click .add_sub_menu_button":"onAddSubMenuButtonClick"
  initialize: ->
    #初始化
    @menuItems = []

    #监听全局事件
  render:->
    super
    #渲染
    @$el.html @template()
    @$el.prop 'class', 'sub_menus'
    @addButton = @$(".add_sub_menu_button")
    
    #子菜单
    submenus = @model.get "submenus"

    self = @
    _.each submenus.models,(value,index,list) ->
      item = new SubMenuItem model:value
      $(item.render().el).insertAfter self.addButton
      self.menuItems.push item

    if submenus.length>=5
      @addButton.hide()

    #监听添加
    @listenTo submenus,"add",@addSubMenu
    @listenTo submenus,"remove",@removeSubMenu
    @listenTo submenus,"sort",@sortMenu

    return @
  addSubMenu:(data)->
    #添加一个子菜单
    item = new SubMenuItem model:data
    $(item.render().el).insertAfter @addButton

    @menuItems.push item

    #子菜单
    submenus = @model.get "submenus"

    if submenus.length>=5
      @addButton.hide()
  removeSubMenu:->
    #子菜单
    submenus = @model.get "submenus"

    if submenus.length<5
      @addButton.show()

    submenus resetIndexs
  onAddSubMenuButtonClick:->
    #添加子菜单按钮被点击
    submenus = @model.get "submenus"
    order = submenus.nextOrder()
    index = submenus.length

    data =
      label: "item "+order
      order: order
      index: index
      menutype: "sub"
      selected: true

    submenus.add new MenuCell data,sort:false
  sortMenu:->
    #排序菜单
    #alert "sort submenus"

    #删除
    _.each @$el.children(),(item,index,arr)->
      if index>0
        $(item).remove()

    _.each @menuItems,(item,index,arr)->
      item.clearListening()

    @menuItems = []

    #子菜单
    submenus = @model.get "submenus"

    #添加
    _.each submenus.models,(value,index,arr)=>
      @addSubMenu value
  close: ->
    #清除监听关闭
    _.each @menuItems,(item,index,arr)->
      item.clearListening()
    @remove()
