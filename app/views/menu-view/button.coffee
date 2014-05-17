common = require 'views/common/utils'

ButtonView = require './button_base'
Submenu = require './submenu'

##
# Main button, with childNodes
#
module.exports = class MainButtonView extends ButtonView
  template: require './templates/button'

  render: ->
    super
    # add submenu view for button
    @submenu = new Submenu parent: this

  deactivate: ->
    super
    @submenu.close()

  activate: ->
    super
    @toggleSubmenu()

  toggleSubmenu: ->
    @submenu.toggle()
    shown = @submenu.$el.is(':visible')
    @trigger 'toggle', shown
