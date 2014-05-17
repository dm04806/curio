Model = require 'models/base/model'

foo2value = (item) ->
  item.value = item.key or item.url
  if item.sub_button
    item.sub_button.forEach foo2value

value2foo = (item) ->
  if item.sub_button
    item.sub_button.forEach value2foo
    return
  if item.type == 'view'
    item.url = item.value
  else
    item.key = item.value || item.name
  delete item.value

module.exports = class Menu extends Model
  kind: 'menu'
  idAttribute: 'media_id'

  defaults:
    items: []

  url: ->
    "#{@apiRoot}/medias/#{@get 'media_id'}/menu"

  toJSON: ->
    obj = super
    obj.items.forEach value2foo
    obj

  parse: (obj) ->
    obj.items.forEach foo2value
    obj
