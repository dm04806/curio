View = require 'views/base'
mediator = require 'mediator'

module.exports = class SiteErrorMain extends View
  autoRender: true
  optionNames: View::optionNames.concat ['error']
  container: 'body'
  id: 'site-error'
  template: require './templates/site-error'
  context: ->
    error = @error
    user: mediator.user
    category: error.category
    title: error.title
    detail: error.detail
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


