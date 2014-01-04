Visitor = require 'models/user/visitor'

mediator = module.exports = Chaplin.mediator

mediator.user = null
mediator.mediaId = null

mediator.createUser = ->
  mediator.user = new Visitor

mediator.removeUser = ->
  mediator.user.dispose()
  mediator.user = null

mediator.login = (token) ->
  if mediator.user instanceof Visitor
    localStorage.setItem 'token', token
    mediator.createUser()
    mediator.user.set {token}

mediator.logout = () ->
  return unless mediator.user
  localStorage.removeItem 'token'
