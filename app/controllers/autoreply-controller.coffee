HomeController = require './home-controller'
AutoreplyIndex = require 'views/autoreply-view'
mediator = require 'mediator'

module.exports = class AutoreplyController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'responder', (err, responder) =>
      responder.setFilter(opts.query.tab or 'text')
      @view = new AutoreplyIndex
        region: 'main'
        model: responder
