utils = require 'lib/utils'

# Store Key
SK_ALL_MEDIA_ADMINS = 'all_media_admins'
SK_MEDIA_ADMIN = 'media_admin'


pickAdmin = (availables, can_empty) ->
  current = currentAdmin()
  if not availables or not availables.length
    return if can_empty then current
  utils.store SK_ALL_MEDIA_ADMINS, availables
  # Find out which media is now managing
  if current
    for admin in availables
      if admin.media_id is current.media_id
        current.media = admin.media or current.media
        return current
  # Pick the first if the localStorage didn't matched
  admin = availables[0]
  utils.store SK_MEDIA_ADMIN, admin
  return admin


currentAdmin = ->
  utils.store SK_MEDIA_ADMIN

allAdmins = (value) ->
  utils.store SK_ALL_MEDIA_ADMINS, value

module.exports =
  pickAdmin: pickAdmin
  currentAdmin: currentAdmin
  allAdmins: allAdmins
