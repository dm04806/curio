Model = require 'models/base/model'

permissions = require './permissions'

module.exports = class User extends Model

  hasRole: (role, mediaId) ->
    if role is 'user'
      return @get('_id') isnt null
    if role is 'super'
      return @get('level') is 'super'
    if not mediaId
      return false
    myRoles = @roles or {}
    return myRoles[mediaId] is role

  permitted: (action, mediaId=null) ->
    roles = permissions[action] # ['editor', 'mananger']
    for role in roles
      if @hasRole(role, mediaId)
        return true
    return false
