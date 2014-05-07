Model = require 'models/base/model'

module.exports = class Menu extends Model
	kind: 'menu'
	defaults:
		menu:""
	url: ->
		"#{@apiRoot}/medias/#{@get 'media_id'}/menu"
		#"#{@apiRoot}/medias/60/menu"
	idAttribute: 'media_id'
	initialize:->
		# alert "init menu model"
		# alert @get "buttons"
		#@save (menu:"test for save"),(error:@saveError,success:@saveSuccess)
	saveSuccess:(ret)->
		alert "save success "+ret
	saveError:(error)->
		alert "save error "+error
		