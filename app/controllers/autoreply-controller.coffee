HomeController = require './home-controller'
AutoreplyIndex = require 'views/autoreply-view'
mediator = require 'mediator'

module.exports = class AutoreplyController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'responder', opts.query, (err, responder) =>
      @view = new AutoreplyIndex
        region: 'main'
        model: responder
