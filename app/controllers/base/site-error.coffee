mediator = require 'mediator'
utils = require 'lib/utils'
ErrorView = require 'views/errors/site-error'
PageView = require 'views/base/page'
{CurioError} = require 'models/errors'

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
