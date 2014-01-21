PageView = require 'views/base/page'

mediator = Chaplin.mediator

require './session'
require './transition'
require './site-error'

module.exports = class Controller extends Chaplin.Controller
  pageLayout: 'normal'
  # All pages requires login by default
  needPermit: 'user'

  checkPermission: ->
    need_permit = @needPermit
    return true unless need_permit
    if need_permit
      if not mediator.user
        mediator.loginReturn = window.location.path
        return @redirectTo 'login'
      if not mediator.user.permitted(need_permit)
        mediator.publish 'site-error', 403
    true

  beforeAction: ->
    return 403 if @checkPermission() is false
    @compose 'site', PageView, layout: @pageLayout
    return

  index: ->
    @view = new @main region: 'main'
