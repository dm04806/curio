{API_ROOT} = require 'consts'
{BootError} = require 'models/boot'
utils = require 'lib/utils'
mediator = require 'mediator'

$.ajaxSetup
  dataType: 'json',
  beforeSend: (xhr) ->
    url = @url or ''
    if url.indexOf(API_ROOT) == 0
      @xhrFields =
        withCredentials: true
    if @type in ['POST', 'PUT', 'DELETE']
      xhr.setRequestHeader('x-csrf-token', $.cookie('csrf'))

sync = Backbone.sync
Backbone.sync = (args...) ->
  return sync.apply(this, args) unless mediator.site_error
  # if site error found, do fetch when error resolved
  promise = $.Deferred()
  mediator.site_error.on 'resolve', =>
    sync.apply(this, args)
    .done ->
      promise.resolve arguments...
    .error ->
      promise.reject arguments...
  return promise

module.exports = class Application extends Chaplin.Application
  title: 'Curio'
  start: ->
    mediator.subscribe 'initialize', (bs) =>
      utils.debug '[curio start]', bs
      @title = __('site.name')
      if not bs
        mediator.execute 'site-error', new BootError 'start'
      mediator.unsubscribe 'initialize'
      super
