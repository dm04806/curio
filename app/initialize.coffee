Application = require 'application'
i18n = require 'i18n'
utils = require 'lib/utils'
routes = require 'routes'
consts = require 'consts'
mediator = require 'mediator'

$.ajaxSetup
  dataType: 'json',
  beforeSend: (xhr) ->
    url = @url or ''
    if url.indexOf(consts.API_ROOT) == 0
      @xhrFields =
        withCredentials: true
    if @type in ['POST', 'PUT', 'DELETE']
      xhr.setRequestHeader('x-csrf-token', $.cookie('csrf'))

initialize = (err, bs) ->
  utils.debug('[curio start]', bs)

# Initialize the application only when i18n ready.
$.when(i18n.fetch('messages'), $.get(consts.API_ROOT))
.done (arg1, arg2) ->
  bs = arg2[0] # bootstrap data
  mediator.publish 'initialize', bs
.fail (xhr, status, err)->
  console.log arguments
  i18n.fetch('messages').done ->
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

