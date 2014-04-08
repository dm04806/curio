Menu = require './menu'

##
#
# Switchable Tabs based on menu
#
# #
module.exports = class TabsView extends Menu
  className: 'nav nav-tabs'

  render: ->
    super
    tgl = if 'nav-pills' in @className then 'pill' else 'tab'
    @$el.find('.nav>li>a').data('toggle', tgl)

  doSwitch: (e) ->
    name = $(e.currentTarget).data('name')
    view = @subview name

  events:
    'click .nav>li': 'doSwitch'
