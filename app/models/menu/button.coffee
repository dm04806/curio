Model = require 'models/base/model'

module.exports = class MenuCell extends Model
  kind: "menu_button"

  defaults:
    type: "click"
    name: ""
    value: ""
    children: null
