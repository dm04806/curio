View = require './view'

module.exports = class ItemView extends View
  autoRender: true
  tagName: 'tr'
  render: ->
    super
    @$el.data 'id', @model.id

