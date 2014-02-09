MenuView = require './menu'


# Menu which active state binds with window.location
module.exports = class GlobalMenuView extends MenuView
  listen:
    'dispatcher:dispatch mediator': 'updateState'
