utils = require 'lib/utils'
User = require 'models/user'
Media = require 'models/media'
session = require 'models/session'
{API_ROOT} = require 'consts'

mediator = require 'mediator'

mediator.user = null
mediator.media = null

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
  admins = data.admins

  user = mediator.user = new User(userInfo)

  if user.isSuper and not admins or not admins.length
    admins = session.allAdmins() or []

  roles = user.roles = {}
  # assign media admin role to user
  for admin in admins
    roles[admin.media_id] = admin.role
  admin = session.pickAdmin(admins, user.isSuper)
  if admin
    media = admin.media or { id: admin.media_id }
    mediator.media = new Media media
  utils.debug '[login]', user
  mediator.publish 'session:login'


mediator.setHandler 'toggle-media', (media_id) ->
  all = session.allAdmins()
  return unless all
  for admin in all
    if admin.media_id is media_id
      utils.store 'media_admin',
        role: admin.role
        media_id: media_id
        media: admin.media
      utils.debug 'change media to ->', admin.media
      mediator.media = new Media admin.media
      mediator.publish 'session:togglemedia', admin
      return admin
