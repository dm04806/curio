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
    context = @context
    if 'function' is typeof context
      context = @context(data)
    ret = {}
    data = super
    _.assign ret, helper.globals, context, data
    ret.__proto__ = data.__proto__
    if @debug
      utils.debug '[template]', ret
    return ret

  dispose: ->
    @trigger 'dispose'
    super
