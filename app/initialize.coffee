Application = require 'application'
i18n = require 'i18n'
utils = require 'lib/utils'
routes = require 'routes'
consts = require 'consts'

# fetch i18n and bootstrap data(user info, etc..)
fetchBootstrap = () ->
  $.ajax
    url: consts.API_ROOT
    dataType: 'json'

# Initialize the application only when i18n ready.
$.when i18n.fetch('messages'), fetchBootstrap()
.done ->
  $ ->
    # initialize on DOM ready
    new Application {
      title: __('site.name'),
      controllerSuffix: '-controller',
      routes
    }
.fail (xhr, status, err)->
  document.write 'Server error. Please try again letter.'
  utils.log(status, err)
