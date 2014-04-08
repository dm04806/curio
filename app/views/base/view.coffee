helper = require 'lib/view-helper' # Just load the view helpers, no return value
utils = require 'lib/utils'

module.exports = class View extends Chaplin.View
  initialize: ->
    # Template data context
    @data = {}
    @context = @context or {}
    super

  # Auto-save `template` option passed to any view as `@template`.
  # `data` and `items` can be misc data which has no need to be a @model or @collection
  optionNames: Chaplin.View::optionNames.concat ['template', 'data', 'items']

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    if not @template
      utils.error 'template for %s not found.', this
    @template

  getTemplateData: ->
    data = super
    context = _.result this, 'context'
    _.defaults data, context, @data, helper.globals
    if @debug
      utils.debug '[template]', data
    return data

  dispose: ->
    @trigger 'dispose'
    super
