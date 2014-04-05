View = require 'views/base'
utils = require 'lib/utils'


# Tab switcher
module.exports = class TabsView extends View
  autoRender: true
  templates: require './templates/tab'

  getTab: (e) ->
    throw new Error('Please implement @getTab')

  context: ->
    items: @data

  switch: (e) ->
    id = $(e.target).data('id')
    tab = @getTab(id)
    @currentTab?.dispose()
    tab.render()

  events:
    'click .switch': 'switch'
