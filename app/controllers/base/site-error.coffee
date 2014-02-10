mediator = require 'mediator'
ErrorView = require 'views/errors/site-error'
utils = require 'lib/utils'

mediator.site_error = null

mediator.setHandler 'site-error', (err)->
  mediator.site_error = new ErrorView error: err
  utils.error err

mediator.subscribe 'site-error:resolve', ()->
  # reload page when error is resolved
  mediator.site_error.dispose()
