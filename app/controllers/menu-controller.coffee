HomeController = require './home-controller'
MenuIndex = require 'views/menu-view'
Menu = require 'models/menu'
mediator = require 'mediator'

module.exports = class MenuController extends HomeController
  index: (params, route, opts) ->
    mediator.media.load 'menu', (err, menu) =>
<<<<<<< HEAD
      @view = new MenuIndex
        model: menu
        autoRender: true
        region: 'main'
=======
          @view = new MenuIndex
            model: menu
            autoRender: true
            region: 'main'
>>>>>>> 7a5f9690c6583b305fcc1d790d320d58e22ab48b
    #media = mediator.media
    #model = @model = media.related 'menu', params.id
    
