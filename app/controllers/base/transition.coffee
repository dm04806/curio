# global loading status
mediator = require 'mediator'
{AccessError} = require 'models/errors'

# Override backbone ajax to enable loading status indicators
ajax = Backbone.ajax
Backbone.ajax = (opts, args...) ->
  resolved = false
  setTimeout ->
    # show loading when ajax takes too long
    if not resolved and not $('body').find('.loading-indicator:visible').length
      $('body').addClass('syncing')
  , 800
  _ajax = =>
    ajax.call(this, opts, args...).always (xhr) ->
      resolved = true
      $('body').removeClass('syncing')
    .error (xhr) ->
      # for none GET request, you'd better handle errors for yourself
      return if opts.type isnt 'GET'
      mediator.execute 'ajax-error', xhr
  return _ajax() unless mediator.site_error
  promise = $.Deferred()
  # if site error found, do fetch when error resolved
  mediator.site_error.on 'resolve', ->
    _ajax().done ->
      promise.resolve arguments...
    .error ->
      promise.reject arguments...
  return promise


ANIMATION_END = "webkitAnimationEnd mozAnimationEnd
 MSAnimationEnd oanimationend
 animationend"

$.fn.anim = (cls, options, nextDelay) ->
  @removeClass("animated #{@data('_last_anim')}")
  @data '_last_anim', cls
  if 'number' is typeof options
    options = { duration: "#{options/1000}s" }
  if options?
    css = {}
    for k of options
      css["animation-#{k}"] = options[k]
    @css css
  @queue 'fx', (next) =>
    setTimeout =>
      @addClass("animated #{cls}")
    if nextDelay
      setTimeout next, nextDelay
    else
      this.one ANIMATION_END, next
  return this

