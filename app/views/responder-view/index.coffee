mediator = require 'mediator'
utils = require 'lib/utils'
Rule = require 'models/responder/rule'
CollectionView = require 'views/base/collection'
Menu = require 'views/widgets/menu'
common = require 'views/common/utils'

navTabs = [
  name: 'autoreply.keyword'
  url: '/autoreply?tab=keyword'
,
  name: 'autoreply.subscribe'
  url: '/autoreply?tab=subscribe'
,
  name: 'autoreply.any'
  url: '/autoreply?tab=any'
]

module.exports = class ResponderIndexView extends CollectionView
  className: 'main-container'
  template: require './templates/index'
  itemView: require './rule'
  listSelector: '#rules'
  animationDuration: 0
  renderItems: false

  render: ->
    filter = @model.filter
    @data.tabname = "autoreply.#{filter}"
    super # render the DOM
    # register tabs view
    tabs = new Menu
      container: @$el.find('.tabs-filter')
      items: navTabs
    tabs.updateState @data.tabname
    @subview 'tabs', tabs
    items = @collection.models.reverse()
    @collection.reset()
    items.forEach (item) =>
      @collection.add item, at: 0

  filterer: (item, index) ->
    if not item.index?
      item.index = @visibleItems.length
    return true if not @model.filter
    item.is(@model.filter)

  filterCallback: (view) ->
    super
    view.renderPtitle()

  ##
  # Add new rule
  newRule: ->
    view = @subview 'newItem'
    # can only have one new rule input
    return view.unfold() if view

    rule = @model.newRule()
    rule.index = -1

    @collection.add rule, {at: 0}

    view = @getViewForItem(rule)
    @subview 'newItem', view

    # Every new rule is unfolded by default
    view.unfold()
    rule.once 'save', =>
      # update rule title
      for item, i in @visibleItems
        item.index = i
        @getViewForItem(item).renderPtitle()

  ##
  # download rules as json
  export: (node) ->
    data = utils.unicodefy(JSON.stringify(@model.rules.serialize(), null, 2))
    uri = "data:application/json;base64,#{btoa(data)}"
    view = common.alert
      title: __('rules.export.title')
      modal_class: 'modal'
      detail: """
        <pre style='max-height:250px;'>#{data}</pre>
        <a href='#{uri}'download='curio-rules.json'>
          #{__('download')}
        </a>
      """
      cancel_button: __('close')
      translate: false

  context: ->
    filter: @model.filter
