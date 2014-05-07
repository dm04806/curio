mediator = require 'mediator'
View = require 'views/base/view'


module.exports = class MenuItem extends View
	tagName: 'div'
	styleset:
		menu_text_color: "#333333"
		menu_background_color: "#efefef"
		menu_text_over_color: "#222222"
		menu_background_over_color: "#ffffff"
	events:
		"mouseover": "onMouseOver"
		"mouseout": "onMouseOut"
		"click li": "onClick"
		"dblclick li": "edit"
		"click .menu_item_console a:first": "edit"
		"click .menu_item_console a:last": "delete"
		"blur .menu_edit": "editComplete"
		"keypress .menu_edit": "onEditorKeyPress"
	listen:
		"change:label model": "render"
		"change:selected model": "selectedChanged"
		"destroy model": "remove"
	initialize: ->
		@editing = false
	render: ->
		#渲染
		@$el.html @template(@model.toJSON())
		@label = @$("li label")
		@bg = @$("li")
		@input = @$(".menu_edit")
		@console = @$(".menu_item_console")

		@label.html @model.get "label"
		@input.val @model.get "label"

		@selectedChanged()

		return @;
	selected: (selected) ->
		#设置选中状态
		@model.set selected:selected
	selectedChanged: ->
		#选中状态变化
		selected = @model.get "selected"

		#alert @model.get("label")+":"+selected

		if selected
			@label.css "color",@styleset.menu_text_over_color
			@bg.css "background-color",@styleset.menu_background_over_color

			mediator.publish "selectedMenuItemChanged",@
		else
			@label.css "color",@styleset.menu_text_color
			@bg.css "background-color",@styleset.menu_background_color
	onMouseOver: ->
		#鼠标滑过
		if not @editing then @console.show()

		@label.css "color",@styleset.menu_text_over_color
		@bg.css "background-color",@styleset.menu_background_over_color
	onMouseOut: ->
		#鼠标滑出
		@console.hide()

		selected = @model.get "selected"

		if not selected
			@label.css "color",@styleset.menu_text_color
			@bg.css "background-color",@styleset.menu_background_color
	onClick: ->
		#点击了
		if @onClickListener then @onClickListener @
		@selected true

		mediator.publish "menuItemClick",@
	setClickListener: (listener) ->
		@onClickListener = listener
	onEditorKeyPress: (e) ->
		#回车
		if e.keyCode is 13 then @editComplete()
	edit: ->
		#进入编辑模式
		@editing = true
		@console.hide()
		@input.show()
		@input.focus()
	editComplete: ->
		#编辑完成
		value = @input.val()
		if $.trim(value).length <= 0
			alert "菜单标签不能够为空"
		else
			@editing = false
			@model.set label:value
			@input.hide()
	clearListening: ->
		@stopListening @model
	delete: ->
		#删除
		if @model.get("submenus")? and @model.get("submenus").length>0
			if not confirm "删除此主菜单将删除其所有的二级菜单？" 
				return false

		@model.destroy()

		return true