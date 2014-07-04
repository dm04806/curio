View = require 'views/base'
utils = require 'lib/utils'

Loc = require 'models/loc'

renderList = (items, level, parent) ->
  level = level or 'country'
  sel = $("""
      <select data-level="#{level}" name="loc_id" class="loc-select form-control">
        <option value="#{parent?.id or ''}">#{__ "loc.#{level}"}</option>
      </select>
    """)
  sel.attr('id', "selloc-#{level}")
  items.forEach (item) ->
    sel.append("<option value='#{item.id}'>#{item.name}</option>")
  sel


CHINA = {
  id: 100000,
  name: '中国'
}

module.exports = class LocSelector extends View
  autoRender: true
  noWrap: true
  template: require './templates/loc_selector'
  debug: true

  render: ->
    if not @collection
      @collection = Loc.collection
        params: {
          level: 'country',
          limit: null,
          current: @data.current
        }
      @collection.fetch().done (res) =>
        @_render(res.items, res.current)
        @_renderCurrent(res.current)
    @_render()

  _render: (coll, cur) ->
    return if @disposed
    sel = renderList(coll or [CHINA])
    # always select china by default
    sel.find("[value=#{CHINA.id}]")
      .attr('selected', true)
    @$el.html(sel)
    @loadChildren(sel) if coll and not cur

  _renderCurrent: (cur) ->
    return unless cur
    frag = $(document.createDocumentFragment())
    @$el.append(sel)
    while cur and cur.siblings and cur.siblings.length
      sel = renderList(cur.siblings, cur.level, cur.parent)
      sel.val(cur.id)
      frag.prepend(sel)
      cur = cur.parent
    @$("select:eq(0)").val(cur.id)
    @$el.append(frag)

  loadChildren: (node) ->
    node = node
    next = node.nextAll("select").val('')
    id = node.val()
    return next.remove() if not id
    loc = new Loc id: id
    # remove children
    loc.fetch().done (ret) =>
      coll = ret.children
      next.remove()
      if coll.length
        level = coll[0].level
        node.after(renderList(coll, level, loc.attributes))

  onSelect: (e) ->
    @loadChildren($(e.target))
    @trigger 'selected', @current()

  current: ->
    cur = @$('option:selected[value!=""]:last')
    ret = @names()
    _.assign ret, {
      id: cur.val(),
      name: cur.text(),
      level: cur.closest('select').data('level'),
      fullName: @fullName(ret),
    }

  names: ->
    names = {}
    @$('option:selected').each (i, item) ->
      cur = $(item)
      names[cur.closest('select').data('level')] = cur.text()
    names

  fullName: (names) ->
    arr = []
    for k, v of names or @names()
      arr.push(v)
    arr.join(' ')

  events:
    'change select': 'onSelect'

