User = require 'models/user'
mediator = module.exports = Chaplin.mediator

mediator.user = null


mediator.setHandler 'logout', ->
  return unless mediator.user
  mediator.user.dispose()
  mediator.user = null

mediator.setHandler 'login', (userInfo) ->
  mediator.user = new User(userInfo)
