Application = require 'application'
boot = require 'models/boot'
i18n = require 'lib/i18n'
utils = require 'lib/utils'
routes = require 'routes'
mediator = require 'mediator'

# Initialize the application only when i18n ready.
$.when(i18n.fetch('messages'), boot())
.done (arg1, arg2) ->
  bs = arg2[0] # bootstrap data
  mediator.publish 'initialize', bs
.fail (xhr, status, err)->
  i18n.fetch('messages').always ->
    utils.error('bootstrap', status, err)
    mediator.publish 'initialize'
  #document.write 'Server error. Please try again letter.'

$ ->
  # initialize on DOM ready
  mediator.app = new Application {
    title: __('site.name'),
    controllerSuffix: '-controller',
    routes
  }
