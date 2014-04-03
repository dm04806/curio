mediator = require 'mediator'
utils = require 'lib/utils'
ErrorView = require 'views/common/site-error'
PageView = require 'views/base/page'
{CurioError,AccessError} = require 'models/errors'

$(window).on 'popstate', ->
  if mediator.site_error
    # closable error will be removed when navigate to other url
    if mediator.site_error.error.closable
      mediator.site_error.resolve()
    else
      location.reload()

mediator.site_error = null

mediator.setHandler 'site-error', (err)->
  # dispose old errors first
  if mediator.site_error
    mediator.site_error.dispose()
    mediator.site_error = null
  if err not instanceof CurioError
    err = new CurioError err
  if err.code is 'need_panel' and mediator.user?.isSuper
    # when no media, redirect to super admin page
    return utils.redirectTo 'super/home#index'
  # try to resolve this error
  err_view = mediator.site_error = new ErrorView error: err
  err_view.on 'resolve', ->
    if mediator.site_error == err_view
      mediator.site_error = null
  err.resolver? err_view
  utils.error err


#
# Ajax error handler
#
mediator.setHandler 'ajax-error', (xhr, fn) ->
  json = xhr.responseJSON or {}
  if xhr.status == 401
    # this ajax request is unauthorized
    err = new AccessError(json.error or 'session_timeout')
  else if xhr.status == 403
    err = new AccessError(json.error or 'not_allowed')
  else if xhr.status == 404
    err = 'not_found'
  else if xhr.status
    err = 'server'
  else
    err = 'network'
  if not fn
    mediator.execute 'site-error', err
  else
    fn err
