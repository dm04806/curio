ColumnedPage = require 'views/base/page'
PermissionDenied = require 'views/errors/403'

mediator = Chaplin.mediator

module.exports = class Controller extends Chaplin.Controller
  # All pages requires login by default
  needPermit: 'user'
  siteView: ColumnedPage
  beforeAction: ->
    console.log this.layout
    @compose 'site', @siteView
    permit = @needPermit
    if permit
      if not mediator.user.get('access_token')
        mediator.loginReturn = window.location.path
        return @redirectTo 'login'
      if not mediator.user.permitted(permit)
        @view = @compose 'site', PermissionDenied
