mediator = require 'mediator'

booted = false

fetchBootstrap = (callback) ->
  $.ajax
    url: '/api/bootstrap'
    dataType: 'json'
  .success (res) ->
    console.log arguments
    callback(null, res)
  .error (res, status, msg) ->
    console.log arguments
    callback('boostrap failed')

module.exports = class Application extends Chaplin.Application
  initMediator: ->
    mediator.createUser()
    super
  start: ->
    # fetch i18n and bootstrap data(user info, etc..)
    fetchBootstrap (err, bs) =>
      super
      console.log err, bs
      if err
        mediator.publish('error', err)
