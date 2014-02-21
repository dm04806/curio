utils = require 'lib/utils'
Layout = require 'views/layout'
Dispatcher = Chaplin.Dispatcher
mediator = require 'mediator'
{BootError} = require 'models/boot'

# load middlewares
require 'controllers/base/transition'
require 'controllers/base/site-error'
require 'controllers/base/session'

module.exports = class Application extends Chaplin.Application
  title: 'Curio'

  initLayout: (options = {}) ->
    options.title ?= @title
    options.skipRouting = '.noscript, [data-toggle]'
    @layout = new Layout options

  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      if not bs
        mediator.execute 'site-error', new BootError 'start'
      mediator.unsubscribe 'initialize'
      super
    mediator.subscribe 'dispatcher:dispatch', (router) ->
      title = null
      if router.view
        title = router.view.$el.find('.view-title h1').text()
      else if document.title == 'Loading..'
        title = ''
      if title != null
        router.adjustTitle(title)
