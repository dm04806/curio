mediator = require 'mediator'
ErrorView = require 'views/errors/site-error'
PageView = require 'views/base/page'
{CurioError} = require 'models/errors'
utils = require 'lib/utils'

mediator.site_error = null

mediator.setHandler 'site-error', (err)->
  if err not instanceof CurioError
    err = new CurioError err
  if err.code is 'need_panel' and mediator.user?.isSuper
    # when no media, redirect to super admin page
    return utils.redirectTo 'super/home#index'
  # try to resolve this error
  mediator.site_error = new ErrorView error: err
  err.resolver? mediator.site_error
  utils.error err
