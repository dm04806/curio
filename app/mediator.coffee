User = require 'models/user'
utils = require 'lib/utils'
mediator = module.exports = Chaplin.mediator

mediator.user = null

mediator.store = (item, value) ->
  if not value
    return localStorage.setItem(item, JSON.stringify(value))
  try
    value = JSON.parse(localStorage.getItem(item))
  catch error
    utils.debug '[curio store]', error
    localStorage.setItem(item, '')
  return value


mediator.setHandler 'logout', ->
  return unless mediator.user
  mediator.user.dispose()
  mediator.user = null

mediator.setHandler 'login', (userInfo) ->
  mediator.user = new User(userInfo)
