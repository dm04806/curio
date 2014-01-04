require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
   # Template data context
  context: {}

  # Auto-save `template` option passed to any view as `@template`.
  optionNames: Chaplin.View::optionNames.concat ['template']

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    @template

  getTemplateData: ->
    data = super
    data = _.extend {}, @context, data
    return data
