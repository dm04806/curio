mediator = require 'mediator'
View = require 'views/base/view'

module.exports = class MenuProp extends View
	template: require './templates/menu_prop'
	events:
		"click #save_menu_item_prop_btn":"save"
		"click #menu_pos_up":"upIndex"
		"click #menu_pos_bottom":"downIndex"
		"click #menu_pos_left":"leftIndex"
		"click #menu_pos_right":"rightIndex"
	initialize:->
		#初始化
	render:->
		super
		#渲染

		@$el.html @template()

		@labelInput = @$("#menu_label")#标签
		@combox = @$("#menu_type")#类型
		@valueInput = @$("#menu_value")#值

		return @
	setProp:->
		@labelInput.val @model.get "label"
		@combox.val @model.get "type"
		@valueInput.val @model.get "value"
	setMenuItemModel:(model)->
		#设置菜单的数据对象
		if @model? then @stopListening @model
		@model = model
		@listenTo @model,"change",@setProp
		@setProp()
	upIndex:->
		#操作子菜单的位置上移动
		# if not @curSubMenuItem return
		# index = @model.get("index");
		# submenus = subMenus.model.get("submenus");
		# submenus.swapIndexs(index,index+1)
		mediator.publish "changeMenuIndex","up",@model.get("index")
	downIndex:->
		#操作子菜单的位置下移动
		# if(!curSubMenuItem) return;
		# var index=this.model.get("index");
		# var submenus=subMenus.model.get("submenus");
		# submenus.swapIndexs(index,index-1);
		mediator.publish "changeMenuIndex","down",@model.get("index")
	leftIndex:->
		#操作主菜单的位置左移动
		# if(!curMainMenuItem) return;
		# var index=this.model.get("index");
		# menus.swapIndexs(index,index-1);
		mediator.publish "changeMenuIndex","left",@model.get("index")
	rightIndex:->
		#操作主菜单的位置右移动
		# if(!curMainMenuItem) return;
		# var index=this.model.get("index");
		# menus.swapIndexs(index,index+1);
		mediator.publish "changeMenuIndex","right",@model.get("index")
	save:->
		#保存
		data =
			label:@labelInput.val()
			type:@combox.val()
			value:@valueInput.val()
		@model.set data
