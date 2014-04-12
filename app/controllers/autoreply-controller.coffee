HomeController = require './home-controller'
AutoreplyIndex = require 'views/responder-view'
mediator = require 'mediator'

module.exports = class AutoreplyController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'responder', (err, responder) =>
      responder.setFilter(opts.query.tab or 'keyword')
      @view = new AutoreplyIndex
        region: 'main'
        model: responder
