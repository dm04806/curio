View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
session = require 'models/session'

module.exports = class HeaderView extends View
  noWrap: true
  in_super: false
  container: '#header',
  containerMethod: 'html',
  template: require './templates/header'
  context: ->
    user = mediator.user
    if not user
      @subscribeEvent 'session:login', =>
        @render $el: @$el
    return unless user
    all_admins = mediator.all_admins
    user: user.attributes
    all_admins: all_admins
    other_admins: all_admins?.filter (item) -> item.id != mediator.media?.id
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
