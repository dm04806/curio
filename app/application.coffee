utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Application extends Chaplin.Application
  title: 'Curio'
  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      @title = __('site.name')
      if not bs
        mediator.execute 'site-error', 'bootfail'
      else if bs.user
        mediator.execute 'login', bs
      mediator.unsubscribe 'initialize'
      super
