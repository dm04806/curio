helper = require 'lib/view-helper' # Just load the view helpers, no return value
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class View extends Chaplin.View
  # Auto-save `template` option passed to any view as `@template`.
  # `data` and `items` can be misc data which has no need to be a @model or @collection
  optionNames: Chaplin.View::optionNames.concat ['template', 'data', 'items']

  initialize: (options) ->
    # Template data context
    @data = @data or {}
    @context = @context or {}
    super

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    if not @template
      utils.error 'template for %s not found.', this
    @template

  getTemplateData: ->
    data = super
    context = _.result this, 'context'
    _.defaults data, @data, context, helper.globals
    if @debug
      utils.debug '[template]', data
    return data

  dispose: ->
    @trigger 'dispose'
    super

  dissmissAlert: (node) ->
    node.closest('.alert').anim('fadeOut', 300).promise().done -> @remove()

  events:
    # operation handler
    'click [data-op]': (e) ->
      e.preventDefault()
      e.stopPropagation()
      node = $(e.currentTarget)
      op = node.data('op')
      if op not of this
        throw new Error("How to \"#{op}\"?")
      @[op](node)

  adjustTitle: ->
    return if @region isnt 'main'
    subtitle = @$el.find('.view-title h1').text() or ''
    mediator.execute('adjustTitle', subtitle)

  listen:
    'addedToDOM': 'adjustTitle'
