Model = require '/models/base/model'
permissions = require './permissions'

mediator = Chaplin.mediator

module.exports = class User extends Model

  hasRole: (role, mediaId=null) ->
    mediaId = mediaId or mediator.mediaId
    if role is 'user'
      return @get('_id') isnt null
    myRoles = @get('roles') or {}
    if role is 'super'
      return myRoles['-1'] is 1
    return myRoles[mediaId] is role

  permitted: (action, mediaId=null) ->
    roles = permissions[action] # ['editor', 'mananger']
    for role in roles
      if @hasRole(role, mediaId)
        return true
    return false
