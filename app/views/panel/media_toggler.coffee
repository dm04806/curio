View = require 'views/base'
utils = require 'lib/utils'
mediator = require 'mediator'
session = require 'models/session'

module.exports = class MediaTogglerView extends View
  autoRender: true
  className: 'nav navbar-nav'
  tagName: 'ul'
  template: require './templates/media_toggler'
  context: ->
    all_admins: session.allAdmins()
    media: mediator.media?.attributes
  render: ->
    super
    mediator.subscribe 'session:togglemedia', (media) =>
      @render()
      mediator.unsubscribe 'session:togglemedia'
  events:
    'click a[data-media]': (e) ->
      mediator.execute 'toggle-media', $(e.currentTarget).data('media')
