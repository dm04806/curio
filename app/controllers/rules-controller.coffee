HomeController = require './home-controller'
RulesIndex = require 'views/rules-view'
mediator = require 'mediator'

module.exports = class RulesController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'responder', (err, responder) =>
      responder.setFilter(opts.query.tab or 'keyword')
      @view = new RulesIndex
        region: 'main'
        collection: responder.getRules()
        model: responder
