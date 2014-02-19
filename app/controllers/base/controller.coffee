PageView = require 'views/base/page'

mediator = require 'mediator'
{AccessError} = require 'models/errors'
{SITE_ROOT} = require 'consts'
{reverse,store} = require 'lib/utils'

module.exports = class Controller extends Chaplin.Controller
  pageLayout: 'normal'
  # All pages requires login by default
  needPermit: 'user'

  checkPermission: ->
    permit = @needPermit
    return true unless permit
    if permit
      if not mediator.user
        store 'login_return', window.location.href
        if not mediator.site_error
          window.location = reverse 'login#index'
        return
      if not mediator.user.permitted(permit, mediator.media)
        mediator.execute 'site-error', new AccessError "need_#{permit}"
    true

  beforeAction: ->
    return 403 if @checkPermission() isnt true
    @reuse 'site', PageView, layout: @pageLayout
    setTimeout =>
      title = null
      if @view
        title = @view.$el.find('.view-title h1').text()
      else if document.title == 'Loading..'
        title = ''
      if title != null
        @adjustTitle(title)

  index: ->
    if @main
      @view = new @main region: 'main'
