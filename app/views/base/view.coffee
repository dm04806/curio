helper = require 'lib/view-helper' # Just load the view helpers, no return value
utils = require 'lib/utils'

module.exports = class View extends Chaplin.View
   # Template data context
  context: {}

  # Auto-save `template` option passed to any view as `@template`.
  optionNames: Chaplin.View::optionNames.concat ['template']

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    if not @template
      utils.error 'template for %s not found.', this
    @template

  getTemplateData: ->
    data = super
    context = _.result this, 'context'
    _.defaults data, context, helper.globals
    if @debug
      utils.debug '[template]', data
    return data

  dispose: ->
    @trigger 'dispose'
    super
