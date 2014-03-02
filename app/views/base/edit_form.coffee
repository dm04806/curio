FormView = require './form'

module.exports = class EditFormView extends FormView
  # the front end validations
  validates: {}
  validate: (name, elem) ->
    fn = @validates[name]
    return unless fn
    fn.call(this, elem)
  submit: (e) ->
    super
    form = e.target
    model = @model
    updatables = model.defaults
    if not updatables
      throw new Error 'set @model.default as updatable attributes'
    attrs = {}
    for elem in form.elements
      name = elem.name
      # do the validation
      err = @validate(name, elem)
      if not err
        @row_msg name
      else
        @row_msg name, err
        @$el.delay(800).promise().done (=> @enable())
        return # just break on errors
      if name of updatables
        attrs[name] = $.trim(elem.value)
    model.save(attrs).always =>
      @$el.promise().done (=> @enable())
    .done (res) =>
      @model.set(res)
      @msg "edit_#{model.kind}.success", 'success', 1200
      @$el.promise().done =>
        @trigger 'submitted', res
    .error (xhr) =>
      json = xhr.responseJSON
      error = json?.error or 'network_error'
      @$el.delay(800)
      # display validation errors
      if not json
        return @msg "edit_#{model.kind}.#{error}"
      detail = if 'object' == typeof json.detail then json.detail else {}
      if Object.keys(detail).length
        for row, errs of json.detail
          @row_msg row, "edit_#{model.kind}.#{row}.#{errs.pop()}"
        first = @$el.find('.has-error:visible').eq(0)
        if first.length
          $('body,html').animate { scrollTop: first.offset().top - 80 }, ->
            first.find(':input').focus()
      else
        @msg "edit_#{model.kind}.#{error}", 'danger'
