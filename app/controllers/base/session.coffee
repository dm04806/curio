User = require 'models/user'
{API_ROOT} = require 'consts'

mediator = require 'mediator'

mediator.user = null

mediator.setHandler 'logout', ->
  return unless mediator.user
  mediator.user.dispose()
  mediator.user = null
  $.ajax
    url: "#{API_ROOT}/auth"
    type: 'DELETE'

mediator.setHandler 'login', (userInfo) ->
  mediator.user = new User(userInfo)
