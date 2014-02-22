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
      # There is already an error, don't continue no matter what
      return false if mediator.site_error
      if not mediator.user
        store 'login_return', window.location.href
        @redirectTo 'login#index'
        return false
      if not mediator.user.permitted(permit, mediator.media)
        mediator.execute 'site-error', new AccessError "need_#{permit}"
        return false
    true

  _beforeAction: ->
    @reuse 'site', PageView, layout: @pageLayout

  beforeAction: ->
    promise = $.Deferred()
    promise.done (=> @_beforeAction())
    defer = ->
      mediator.site_error.on 'resolve', ->
        promise.resolve()
      return promise
    permit = =>
      if @checkPermission()
        promise.resolve()
      return promise
    return if mediator.site_error then defer() else permit()

  index: (params) ->
    if not @view and @main
      @view = new @main region: 'main', params: params
