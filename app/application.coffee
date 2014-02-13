utils = require 'lib/utils'
mediator = require 'mediator'
{BootError} = require 'models/boot'

# load middlewares
require 'controllers/base/transition'
require 'controllers/base/site-error'
require 'controllers/base/session'

module.exports = class Application extends Chaplin.Application
  title: 'Curio'
  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      if not bs
        mediator.execute 'site-error', new BootError 'start'
      mediator.unsubscribe 'initialize'
      super
