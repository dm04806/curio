Model = require 'models/base/model'
mediator = require 'mediator'

permissions = require './permissions'

module.exports = class User extends Model
  kind: 'user'

  initialize: ->
    super
    @on 'sync', ->
      mediator.publish 'users:update'

  defaults:
    uid: null
    name: null
    email: null
    desc: null

  uniqName: ->
    "#{@get('name') or '[no name]'} (#{@get('uid')})"

  hasRole: (role, mediaId) ->
    if role is 'login'
      # only need login
      return @get('_id') isnt null
    isSuper = @isSuper
    return isSuper if role is 'super'
    return false if not mediaId
    myRoles = @roles or {}
    if role is 'media'
      # need at least a media
      passed = mediaId isnt null
    else if not mediaId
      passed = false
    else
      mediaId = mediaId.id or mediaId
      passed = myRoles[mediaId] is role
    # super user can do anything
    return isSuper or passed

  permitted: (action, mediaId=null) ->
    roles = permissions[action] # ['editor', 'mananger']
    for role in roles
      if @hasRole(role, mediaId)
        return true
    return false

Object.defineProperty User.prototype, 'isSuper',
  get: ->
    @get('level') is 'super'
