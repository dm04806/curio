mediator = require 'mediator'
ErrorView = require 'views/errors/site-error'

mediator.site_error = null

code2cat =
  403: 'warning'

mediator.setHandler 'site-error', (err, category)->
  mediator.site_error = err
  category = category or code2cat[err]
  mediator.site_error = new ErrorView error: err, category: category

mediator.subscribe 'site-error:resolve', ()->
  # reload page when error is resolved
  mediator.site_error.dispose()
