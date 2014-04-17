FormView = require './form'

##
# EditForm, aka. ModalForm,
# form with a modal, use `modal.save` to submit,
# and call `modal.validate()` before submit
#
module.exports = class EditFormView extends FormView
  # the front end validations
  validates: {}

  validate: (name, elem) ->
    fn = @validates[name]
    return unless fn
    fn.call(this, elem)

  _submit: (e) ->
    form = e.target
    model = @model

    updatables = model.defaults

    if not updatables
      throw new Error 'set @model.default as updatable attributes'

    attrs = {}

    for elem in form.elements
      name = elem.name
      # don't validate on elements with no name
      continue if not name
      # dont validate hidden inputs
      continue if elem.type == 'hidden'
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
    .done (res) => @_submitDone(res)
    .error (xhr) => @_submitError(xhr)

  # display validation errors
  _submitError: (xhr) ->
    @$el.delay(800)

    json = xhr.responseJSON
    error = json?.error or 'network_error'
    return @msg "edit_#{@model.kind}.#{error}" if not json

    detail = if 'object' == typeof json.detail then json.detail else {}

    # display error details by row
    for row, errs of json.detail
      @row_msg row, "edit_#{@model.kind}.#{row}.#{errs.pop()}"

    first = @$el.find('.has-error:visible').eq(0)
    if first.length
      $('body,html').animate { scrollTop: first.offset().top - 80 }, ->
        first.find(':input').focus()
    else
      @msg "edit_#{@model.kind}.#{error}", 'danger'

  _submitDone: (res) ->
    @model.set(res)
    @msg "edit_#{@model.kind}.success", 'success', 1200
    @$el.promise().done =>
      @trigger 'submitted', res
