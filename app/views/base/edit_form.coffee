FormView = require './form'

module.exports = class EditFormView extends FormView
  validates: {}
  submit: (e) ->
    super
    form = e.target
    model = @model
    validates = @validates
    updatables = model.defaults
    if not updatables
      throw new Error 'set @model.default as updatable attributes'
    attrs = {}
    for elem in form.elements
      name = elem.name
      if name of updatables
        attrs[name] = $.trim(elem.value)
      if name of validates
        err = validate[name].call(this, elem)
        if not err
          @row_msg name
    model.set attrs
    model.save().error (xhr) =>
      json = xhr.responseJSON
      error = json?.error or 'network_error'
      @$el.delay(1000)
      if not json
        return @msg "edit_#{model.kind}.#{error}"
      detail = json.detail or {}
      if Object.keys(detail).length
        for row, errs of json.detail
          @row_msg row, "edit_#{model.kind}.#{row}.#{errs.pop()}"
      else
        @msg "edit_#{model.kind}.#{error}", 'warning'
    .done =>
      @msg "edit_#{model.kind}.success", 'success', 1200
    .always =>
      @$el.promise().done (=> @enable())
