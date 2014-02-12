{API_ROOT} = require 'consts'
utils = require 'lib/utils'
mediator = require 'mediator'
{CurioError} = require 'models/errors'

boot = ->
  $.get(API_ROOT).done (bs) ->
    if bs?.user
      mediator.execute 'login', bs

boot.BootError = class BootError extends CurioError
  code: 'bootfail'
  constructor: (@from) ->
  resolver: (view) ->
    check = ->
      boot().done (res) ->
        if res
          view.resolve()
          if not res.user
            utils.store 'login_return', window.location.href
            utils.redirectTo 'login#index'
        else
          # no res means server error
          setTimeout check, 6000
      .error ->
        # request error is more like connection problem
        setTimeout check, 3000
    check()

module.exports = boot
