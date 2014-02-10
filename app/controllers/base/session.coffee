utils = require 'lib/utils'
User = require 'models/user'
Media = require 'models/media'
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

mediator.setHandler 'login', (data) ->
  userInfo = data.user
  admins = data.admins
  user = mediator.user = new User(userInfo)
  roles = {}
  # assign media admin role to user
  for item in admins
    roles[item.media_id] = item.role
  mediator.user.roles = roles
  utils.debug '[login]', user
  admin = pickMedia(admins)
  if admin
    mediator.media = new Media admin.media

noAdmin = ->
  stored = utils.store 'media'
  if mediator.user.isSuper
    # Super user can admin any media
    return stored

pickMedia = (availables) ->
  if not availables or not availables.length
    return noAdmin()
  all_medias = availables.map (item) ->
    item.media.role = item.role
    return item.media
  utils.store 'all_medias', all_medias
  # Find out which media is now managing
  current = utils.store 'media'
  if current
    for admin in availables
      if admin.media_id is current.media_id
        return current
  # Pick the first if the localStorage didn't matched
  admin = availables[0]
  utils.store 'media', admin
  return admin

