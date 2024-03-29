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
  if err.code is 'need panel' and mediator.user?.isSuper
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
mediator.setHandler 'ajax-error', (xhr) ->
  err = utils.xhrError(xhr)
  mediator.execute 'site-error', err
