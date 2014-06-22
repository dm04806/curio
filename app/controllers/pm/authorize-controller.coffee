Controller = require 'controllers/base/controller'
{store} = require 'lib/utils'
mediator = require 'mediator'

##
# PM Login controller
module.exports = class PMController extends Controller
  needPermit: null
  pageLayout: 'single'
  main: require 'views/pm/authorize'
  index: ->
    super
    @subscribeEvent 'auth:login', =>
      # redirect to places view
      location.href = '/places'
