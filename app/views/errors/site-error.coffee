View = require 'views/base'
mediator = require 'mediator'

module.exports = class SiteErrorMain extends View
  autoRender: true
  optionNames: View::optionNames.concat ['error', 'category']
  container: 'body'
  id: 'site-error'
  template: require './templates/site-error'
  context: ->
    category: @category or 'danger'
    title: __g("error.#{@error}.title") or __('error.general')
    detail: __g("error.#{@error}.detail")
  listen:
    'addedToDOM': ->
      $('body').addClass('has-site-error')
      #setTimeout ->
        #height = Math.max($(window).height(), $('body').outerHeight())
        #$('#site-error').height(height)
      #, 200
    'dispose': ->
      $('body').removeClass('has-site-error')
  resolve: ->
    setTimeout ->
      mediator.publish 'site-error:resolve'
  events:
    'click a': 'resolve'


