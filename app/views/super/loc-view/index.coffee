ListableView = require 'views/base/listable'
Loc = require 'models/loc'

Selector = require 'views/widgets/loc_selector'


module.exports = class LocIndexView extends ListableView
  _model: Loc
  template: require './templates/index'
  context:
    thead: require './templates/thead'
  itemTemplate: require './templates/row'
  render: ->
    super
    @subview 'selector', new Selector el: @$('.loc-selector')

