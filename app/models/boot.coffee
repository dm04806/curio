{API_ROOT} = require 'consts'
utils = require 'lib/utils'
mediator = require 'mediator'
session = require 'models/session'
{CurioError,RetriableError} = require 'models/errors'

boot = ->
  media_id = session.currentMedia()
  # pass current managing media_id to server
  $.get(API_ROOT + '/', { current: media_id }).done (bs) ->
    if bs?.user
      mediator.execute 'login', bs

boot.BootError = class BootError extends RetriableError
  code: 'bootfail'
  closable: true
  retry: boot
  constructor: ->

module.exports = boot
