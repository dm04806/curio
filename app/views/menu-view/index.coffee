mediator = require 'mediator'
View = require 'views/base/view'
MainMenuItem = require './main_menu_item'
SubMenuItem = require './sub_menu_item'
SubMenus = require './sub_menus'
MenuProp = require './menu_prop'
MenuCell = require 'models/menu/menu_cell'
MenuList = require 'models/menu/menu_list'

module.exports = class MenuIndexView extends View
  template: require './templates/index'
  mode: "edit"
  events:
    "click .switch_area": "onOperateModeSwitcherClick"#模式切换
    "click .add_main_menu_button": "onAddMainMenuButtonClick"#添加主菜单按钮
  initialize: ->
    #初始化
    @menus = new MenuList
    @listenTo @menus,"add",@addMainMenu
    @listenTo @menus,"remove",@removeMainMenu
    @listenTo @menus,"sort",@sortMenu

    #监听全局事件
    mediator.subscribe "menuItemClick",@selectedMenuItemChanged
    mediator.subscribe "selectedMenuItemChanged",@selectedMenuItemChanged
    mediator.subscribe "changeMenuIndex",@changeMenuIndex
  render: ->
    super
    @modeStatus = @$(".switch_status")
    @modeStatusLabel = @$(".operate_mode_status span")
    @switcher = @$(".switch_area")
    @switcherIcon = @$(".icon_mode_switch")

    @menuProp = new MenuProp
    @$(".menu_main_container").append @menuProp.render().el

    #添加菜单相关
    @mainMenuTitle = @$(".main_menu_title")
    @mainMenuContainer = @$(".main_menus")
    @mainMenuAddButton = @$(".add_main_menu_button")

    #初始化保存的菜单
    #menu_json = '{"buttons":[{"name":"热门活动","sub_button":[{"name":"热门视频","type":"click","key":"video"},{"name":"必玩推荐","type":"click","key":"wan"},{"name":"精彩回顾","type":"click","key":"huigu"},{"name":"演出日历","type":"click","key":"calendar"}]},{"name":"Play","sub_button":[{"name":"罗志祥 Show Lo","type":"click","key":"lzx"}]},{"name":"服务","sub_button":[{"name":"Hotline 客服热线","type":"view","url":"http://kefu"},{"name":"VIP Room 贵宾服务","type":"click","key":"vip"},{"name":"Location 如何到达","type":"view","url":"http://map.baidu.com"},{"name":"Guide 畅游飞碟","type":"view","url":"feidie"}]}]}'
    #@parseMenu JSON.parse(menu_json)

    @parseMenu JSON.parse(@model.get "menu")

  onOperateModeSwitcherClick: ->
    #模式切换
    if @mode is "edit"
      #切换到预览模式
      @mode = "preview"
      @modeStatus.removeClass 'on'
      @switcher.removeClass 'on'
      @switcherIcon.removeClass 'on'
      @modeStatus.addClass 'off'
      @switcher.addClass 'off'
      @switcherIcon.addClass 'off'
      @modeStatusLabel.html "编辑模式已关闭"
    else if @mode is "preview"
      #切换到编辑模式
      @mode = "edit"
      @modeStatus.removeClass 'off'
      @switcher.removeClass 'off'
      @switcherIcon.removeClass 'off'
      @modeStatus.addClass 'on'
      @switcher.addClass 'on'
      @switcherIcon.addClass 'on'
      @modeStatusLabel.html "编辑模式已开启"
  addMainMenu:(data) ->
    #添加一个主菜单
    item = new MainMenuItem model:data
    @mainMenuContainer.append item.render().el

    #监听主菜单点击
    item.setClickListener @onMainMenuItemClick

    @showSubMenusIn data.get "index"

    if @menus.length >= 3
      @mainMenuAddButton.hide()
  removeMainMenu: ->
    #删除了一个主菜单,重新设置索引
    _.each @menus.models,(model,index,context) ->
      model.set index:index

    if @menus.length<3
      @mainMenuAddButton.show()

    @menus.resetIndexs()

    sub_index = @submenus.model.get "index"
    if sub_index < @menus.length
      @setSubMenusPositionIn sub_index
    else
      @submenus.close()
  selectedMenuItemChanged:(item) =>
    #alert "select menu item changed "+item.model.get "label"
    if @selectedMenuItem? and @selectedMenuItem isnt item
      if @selectedMenuItem and @selectedMenuItem.model isnt item.model
        @selectedMenuItem.selected false
      
    @selectedMenuItem = item
    @menuProp.setMenuItemModel item.model
  changeMenuIndex:(type,index)=>
    #改变菜单顺序
    switch type
      when "left"
        @menus.swapIndexs index,index-1
      when "right"
        @menus.swapIndexs index,index+1
      when "up"
        @submenus.model.get("submenus").swapIndexs index,index+1
      when "down"
        @submenus.model.get("submenus").swapIndexs index,index-1
  onMainMenuItemClick:(menuItem) =>
    if (not @submenus? or (@submenus? and menuItem.model isnt @submenus.model))
      index = menuItem.model.get "index"
      @showSubMenusIn index

  onAddMainMenuButtonClick: ->
    #添加一级按钮被点击
    order = @menus.nextOrder()
    index = @menus.length
    sub_menus = new MenuList
    data =
      label:"item "+order
      order:order
      index:index
      menutype: "main"
      submenus:sub_menus
      selected:true

    @menus.add new MenuCell data,sort:false
  showSubMenusIn:(index) ->
    #在指定位置显示子菜单

    if @submenus?
      @submenus.close()

    model = @menus.at index

    @submenus = new SubMenus model:model
    @$el.append @submenus.render().el
    @submenus.$el.css "left",@mainMenuTitle.width()+index*200+171
  setSubMenusPositionIn:(index)->
      #在指定位置显示子菜单
      if @submenus?
        @submenus.$el.css "left",@mainMenuTitle.width()+index*200+171
  sortMenu:->
    #排序菜单
    #alert("sort main menu");

    #删除
    @mainMenuContainer.html("");

    #添加
    _.each @menus.models,(value,index,list)=>
      item = new MainMenuItem model:value
      @mainMenuContainer.append item.render().el

      #监听主菜单点击
      item.setClickListener @onMainMenuItemClick

    #子菜单位置
    if @submenus?
      @setSubMenusPositionIn @submenus.model.get "index"
  parseMenu:(menu)->
    #解析菜单
    buttons = menu["buttons"]
    _.each buttons,(item,index,list)=>
      @formatMenuItemData @menus,item,index,index,index is buttons.length-1
  filterMenuItemData:(item)->
    #筛选菜单数据
    data=
      label:item["name"]
    if not item["sub_button"]?
      #没有子菜单的,需要提取数据
      data["type"] = item["type"]
      if data["type"] is "view"
        data["value"]=item["url"]
      else if data["type"] is "click"
        data["value"]=item["key"]

    return data
  formatMenuItemData:(target_menus,item,order,index,selected)->
    #对菜单数据和子菜单数据进行数据对象化
    #alert(index+":"+item["name"]);

    sub_menus = new MenuList
    data = @filterMenuItemData item
    data["order"] = order
    data["index"] = index
    data["selected"] = selected
    data["submenus"] = sub_menus

    target_menus.add(new MenuCell(data),sort:false)

    #target_menus.create(data,{sort:false,request:false});

    if item["sub_button"]
      #有子菜单
      sub_button = item["sub_button"]

      _.each sub_button,(sub_item,sub_index,list)=>
        @formatMenuItemData sub_menus,sub_item,sub_index,sub_index,false
  formatMenuItemForSave:(data)->
    #格式化菜单数据为微信菜单
    obj=
      name:data.get("label")

    if data.get("submenus")? and data.get("submenus").length > 0
      #有子菜单,子菜单优先
      obj["sub_button"] = []

      _.each data.get("submenus").models,(item,index)=>
        obj["sub_button"].push @formatMenuItemForSave item
    else
      obj["type"] = data.get("type")#类型

      if obj.type is "view"
        #网页视图类型
        obj["url"] = data.get("value")
      else if obj.type is "click"
        #点击类型
        obj["key"] = data.get("value")

    return obj
  save:->
    #alert "save"
    menu = 
      buttons:[]
    _.each @menus.models,(item,index) =>
      obj = @formatMenuItemForSave item
      menu["buttons"].push obj

    menu_json = JSON.stringify(menu)

    #alert menu_json

    @model.save(menu:menu_json).done =>
      alert "保存成功"
    .error(xhr) =>
      alert "保存失败"

  reset:->
    alert "reset"

