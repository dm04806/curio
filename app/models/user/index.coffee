Model = require 'models/base/model'

permissions = require './permissions'

module.exports = class User extends Model
  urlPath: '/users'

  hasRole: (role, mediaId) ->
    if role is 'user'
      return @get('_id') isnt null
    if role is 'super'
      return @get('level') is 'super'
    if not mediaId
      return false
    myRoles = @roles or {}
    # super user can do anything
    return myRoles[mediaId] is role or @isSuper()

  isSuper: ->
    return @hasRole('super')

  permitted: (action, mediaId=null) ->
    roles = permissions[action] # ['editor', 'mananger']
    for role in roles
      if @hasRole(role, mediaId)
        return true
    return false
