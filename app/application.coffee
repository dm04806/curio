utils = require 'lib/utils'
mediator = require 'mediator'

ERRORS = require 'models/errors'


module.exports = class Application extends Chaplin.Application
  title: 'Curio'
  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      @title = __('site.name')
      if bs?.user
        mediator.execute 'login', bs.user
      super
      mediator.unsubscribe 'initialize'
      if not bs
        mediator.execute 'site-error', ERRORS.BOOT_FAIL
