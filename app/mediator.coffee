User = require 'models/user'

mediator = module.exports = Chaplin.mediator

mediator.user = null

mediator.removeUser = ->
  mediator.user.dispose()
  mediator.user = null

mediator.login = (userInfo) ->
  mediator.user = new User(userInfo)

mediator.logout = () ->
  return unless mediator.user
  mediator.removeUser()
