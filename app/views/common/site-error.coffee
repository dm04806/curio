View = require 'views/base'
mediator = require 'mediator'

module.exports = class SiteErrorMain extends View
  autoRender: true
  optionNames: View::optionNames.concat ['error']
  container: 'body'
  id: 'site-error'
  template: require './templates/site-error'
  context: ->
    json = @error.toJSON()
    json.user = mediator.user
    return json
  listen:
    'resolve': 'dispose'
    'dispose': ->
      $('body').removeClass('has-site-error')
  events:
    'click a': 'resolve'
  #render: ->
    #super
    #setTimeout (=> @adjustHeight()), 1000
  adjustHeight: ->
    return if @disposed
    height = Math.max($(window).height(), $('body').outerHeight())
    $('#site-error').height(height)
  resolve: ->
    setTimeout =>
      @trigger 'resolve'
  goback: (node) ->
    history.go(-1)
    href = location.href
    setTimeout ->
      location.href = '/' if href == location.href
    , 100


