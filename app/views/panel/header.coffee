View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
session = require 'models/session'

module.exports = class HeaderView extends View
  noWrap: true
  in_super: false
  container: '#header',
  template: require './templates/header'
  context: ->
    user = mediator.user
    return unless user
    user: user.attributes
    all_admins: session.allAdmins()
    media: mediator.media?.attributes
    in_super: @in_super
    is_super: user.isSuper
  events:
    'click .toggle-locale a': (e) ->
      e.preventDefault()
      i18n = require 'lib/i18n'
      i18n.setLocale $(e.currentTarget).data('locale')
      setTimeout ->
        location.reload()
      , 100
    'click .toggle-media a': (e) ->
      mediator.execute 'toggle-media', $(e.currentTarget).data('media')
