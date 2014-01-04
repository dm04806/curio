Application = require 'application'
i18n = require 'i18n'
routes = require 'routes'

# Initialize the application on DOM ready event.
i18n.ready ->
  $ ->
    new Application {
      title: __('site.name'),
      controllerSuffix: '-controller',
      routes
    }
