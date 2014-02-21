PageView = require 'views/base/page'

mediator = require 'mediator'
{AccessError} = require 'models/errors'
{SITE_ROOT} = require 'consts'
{reverse,store} = require 'lib/utils'

module.exports = class Controller extends Chaplin.Controller
  pageLayout: 'normal'
  # All pages requires login by default
  needPermit: 'user'

  checkPermission: ->
    permit = @needPermit
    return true unless permit
    if permit
      if not mediator.user
        store 'login_return', window.location.href
        if not mediator.site_error
          window.location = reverse 'login#index'
        return
      if not mediator.user.permitted(permit, mediator.media)
        mediator.execute 'site-error', new AccessError "need_#{permit}"
    true

  _beforeAction: ->
    @reuse 'site', PageView, layout: @pageLayout

  beforeAction: ->
    defer = ->
      promise = $.Deferred()
      promise.done run
      mediator.site_error.on 'resolve', ->
        promise.resolve()
      return promise
    run = =>
      @checkPermission()
      @_beforeAction()
    return if mediator.site_error then defer() else run()

  index: (params) ->
    if not @view and @main
      @view = new @main region: 'main', params: params
