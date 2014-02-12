MainView = require 'views/panel/main'

module.exports = class EditModelView extends MainView
  saveModel: (e) ->
    form = e.target
    e.preventDefault()
    model = @model
    for elem in form.elements
      if elem.name? of model.defaults
        model.set(elem.name, elem.value)
    console.log model
    console.log model.hasChanged()
    model.save().error =>
      @msg "edit_#{model.kind}.error"
  msg: (text, type='danger', expires=1200) ->
    msg = @$el.find('.form-message')
      .attr('class', "form-message alert alert-#{type}")
      .html(__g(text) or __(text.replace "_#{@model.kind}", ''))
      .show()
    if expires
      setTimeout ->
        msg.fadeOut()
      , expires
  events:
    'submit .edit-form': 'saveModel'

