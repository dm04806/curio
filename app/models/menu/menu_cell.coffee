Model = require 'models/base/model'

module.exports = class MenuCell extends Model
	kind: "menucell"
	defaults:
		label: "item"
		order: 0
		index: 0
		menutype: "main"
		selected: false
		submenus: []
		type: "click"
		value: ""