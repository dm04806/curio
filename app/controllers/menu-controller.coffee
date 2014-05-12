HomeController = require './home-controller'
MenuIndex = require 'views/menu-view'
Menu = require 'models/menu'
mediator = require 'mediator'

module.exports = class MenuController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'menu', (err, menu) =>
          @view = new MenuIndex
            model: menu
            autoRender: true
            region: 'main'
    #media = mediator.media
    #model = @model = media.related 'menu', params.id
    
