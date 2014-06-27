View = require 'views/base'
utils = require 'lib/utils'

Loc = require 'models/loc'

renderList = (coll, parent) ->
  level = coll.models[0].level_cn()
  sel = $("""
      <select class="loc-select form-control">
        <option value="#{parent?.id}">#{__ level}</option>
      </select>
    """)
  if parent
    sel.attr('id', "selloc-#{parent.level}")
  coll.each (item) ->
    item = item.serialize()
    sel.append("<option value='#{item.id}'>#{item.name}</option>")
  sel


module.exports = class LocSelector extends View
  autoRender: true
  noWrap: true
  template: require './templates/loc_selector'
  debug: true

  render: ->
    if not @collection
      @collection = Loc.collection
        params: { level: 'country', limit: null }
      @collection.fetch().done => @_render()
    else
      @_render()

  _render: (coll) ->
    return if @disposed
    @$el.append(renderList(coll or @collection))


  loadChildren: (e) ->
    node = $(e.target)
    loc = new Loc id: node.val()
    return if not loc.id
    loc.fetch().done (ret) =>
      # remove existing same level
      $("#selloc-#{ret.level} ~ select").remove()
      $("#selloc-#{ret.level}").remove()
      coll = Loc.collection ret.children
      if coll.length
        node.after(renderList(coll, loc.attributes))

  events:
    'change select': 'loadChildren'
