utils = require 'lib/utils'
# Store Key for current admin
SK_MEDIA_ADMIN = 'media_admin'

pickAdmin = (availables) ->
  return if not availables.length
  current = currentMedia()
  # Find out which media is now managing
  if current
    for admin in availables
      if admin.media_id is current
        return admin
  # Pick the first if the localStorage didn't matched
  admin = availables[0]
  currentMedia(admin.media_id)
  return admin

currentMedia = (media_id) ->
  utils.store SK_MEDIA_ADMIN, media_id

module.exports =
  pickAdmin: pickAdmin
  currentMedia: currentMedia
