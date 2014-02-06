PageView = require 'views/base/page'

mediator = require 'mediator'
ERRORS = require 'models/errors'
{SITE_ROOT} = require 'consts'
{store} = require 'lib/utils'

module.exports = class Controller extends Chaplin.Controller
  pageLayout: 'normal'
  # All pages requires login by default
  needPermit: 'user'

  checkPermission: ->
    need_permit = @needPermit
    return true unless need_permit
    if need_permit
      if not mediator.user
        store 'login_return', window.location.href
        if not mediator.site_error
          @redirectTo 'login#index'
        return
      if not mediator.user.permitted(need_permit)
        mediator.execute 'site-error', 403
    true

  beforeAction: ->
    return 403 if @checkPermission() is false
    @reuse 'site', PageView, layout: @pageLayout
    return

  index: ->
    if @main
      @view = new @main region: 'main'
