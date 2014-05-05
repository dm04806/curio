utils = require 'lib/utils'
User = require 'models/user'
Media = require 'models/media'
session = require 'models/session'
{API_ROOT} = require 'consts'

mediator = require 'mediator'

mediator.user = null
mediator.media = null
mediator.all_admins = null

mediator.setHandler 'logout', ->
  return unless mediator.user
  mediator.user.dispose()
  mediator.user = null
  $.ajax
    url: "#{API_ROOT}/auth"
    type: 'DELETE'
  .done ->
    mediator.publish 'session:logout'

mediator.setHandler 'login', (data) ->
  userInfo = data.user
  admins = mediator.all_admins = data.admins or []
  user = mediator.user = new User(userInfo)

  roles = user.roles = {}
  # assign media admin role to user
  for admin in admins
    roles[admin.media_id] = admin.role

  admin = session.pickAdmin(admins, user.isSuper)
  console.log admin
  if admin
    mediator.execute 'toggle-media', admin.media

  utils.debug '[login]', user
  mediator.publish 'session:login'


mediator.setHandler 'toggle-media', (media) ->
  return if not media
  if media not instanceof Media
    media = new Media(media)
  mediator.media = media
