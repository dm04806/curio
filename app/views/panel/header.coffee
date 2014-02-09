View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class HeaderView extends View
  autoRender: true
  noWrap: true
  template: require './templates/header'
  context: ->
    user = mediator.user
    return unless user
    user: user.attributes
    media: mediator.media.attributes
    all_medias: utils.store 'all_medias'
    in_super: false
    is_super: user.isSuper()
  debug: true
  events:
    'click .toggle-locale a': (e) ->
      e.preventDefault()
      i18n = require 'lib/i18n'
      i18n.setLocale e.currentTarget.getAttribute('data-locale')
      setTimeout ->
        location.reload()
      , 100
