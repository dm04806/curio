{API_ROOT} = require 'consts'
utils = require 'lib/utils'
mediator = require 'mediator'
{CurioError,RetriableError} = require 'models/errors'

boot = ->
  $.get(API_ROOT).done (bs) ->
    if bs?.user
      mediator.execute 'login', bs

boot.BootError = class BootError extends RetriableError
  code: 'bootfail'
  retry: boot
  constructor: ->

module.exports = boot
