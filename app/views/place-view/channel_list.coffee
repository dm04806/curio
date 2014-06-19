View = require 'views/base/view'


listItem = (data) ->
  """
  <li>
    <span class="ops">
      <a href="#" data-op="toRemoveItem">
        <span class="icon-circledelete"></span>
      </a>
    </span>
    <a href="/channel/#{data.id}" target="_blank">
      ##{data.scene_id}
      -
      #{data.name}
    </a>
  </li>
  """


module.exports = class ChannelListView extends View
  autoRender: true
  tagName: 'ul'
  className: 'media-list place-channel-list hidden'

  getTemplateFunction: ->

  render: ->
    super
    @renderItems()

  renderItems: ->
    items = @model.get 'channels'
    @$el.html('')
    items?.forEach (item) =>
      @addItem(item)

  addItem: (item) ->
    @$el.append($(listItem(item)).data(item)).removeClass('hidden')

  removeItem: (item) ->
    @$el.find("li[data-id='#{item.id}']").remove()

  toRemoveItem: (node) ->
    node.closest('li').remove()
    @$el.addClass('hidden') unless @$el.children().length

  getChannels: ->
    return @$('li').toArray().map((item) -> $(item).data())

