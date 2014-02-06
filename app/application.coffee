utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Application extends Chaplin.Application
  title: 'Curio'
  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      @title = __('site.name')
      if bs?.user
        mediator.execute 'login', bs.user
        roles = {}
        for item in bs.admins
          roles[item.media_id] = item.role
        mediator.user.roles = roles
        utils.debug '[media admins]', roles
      mediator.unsubscribe 'initialize'
      if not bs
        mediator.execute 'site-error', 'bootfail'
      super
