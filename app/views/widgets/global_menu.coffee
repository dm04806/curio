MenuView = require './menu'

# Menu which has active state binds to window.location
module.exports = class GlobalMenuView extends MenuView
  listen:
    'dispatcher:dispatch mediator': 'updateState'
