ItemView = require 'views/base/collection_item'
User = require 'models/user'

BG_MODIFIED = '#fefee9'

module.exports = class MediaRowView extends ItemView
  template: require './templates/row'
  updateAdmins: ->
    @render() # rerender item
    # give an animation to get the user's attention
    node = @$el.children()
    color = node.css('backgroundColor')
    console.log color
    node.css('backgroundColor', BG_MODIFIED)
      .delay(1000)
      .animate({
        backgroundColor: color
      }, 600)
  listen:
    'change model': 'updateAdmins'
