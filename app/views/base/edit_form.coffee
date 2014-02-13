FormView = require './form'

module.exports = class EditFormView extends FormView
  submit: (e) ->
    super
    form = e.target
    e.preventDefault()
    model = @model
    for elem in form.elements
      if elem.name? of model.defaults
        model.set(elem.name, elem.value)
    model.save().error =>
      @msg "edit_#{model.kind}.error"
      @$alert.promise().done (=> @enable())
