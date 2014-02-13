MainView = require './main'
utils = require 'lib/utils'

module.exports = class EditModelView extends MainView
  t: (text) ->
    __g(text) or __(text.replace "_#{@model?.kind}", '')
  msg: (text, type='danger', expires='flash') ->
    alerted = @$el.find('.alert').length
    text = @t(text)
    msg = @$el.find('.form-message')
      .html("<div class=\"alert alert-#{type}\">#{text}</div>")
    alert = @$alert = msg.find('.alert')
    if 'number' == typeof expires
      alert.delay(1200) # show message for 1.2s
         # start a fadeOutDown with duration 400ms
        .anim('fadeOutDown', 400, 200)
         # then start slideUp in 200ms
        .slideUp(300)
      alert.promise().done =>
        # when all animation is done, remove this alert
        alert.remove()
        @$alert = null
    else if alerted and type != 'success'
      msg.anim(expires)
    return msg
  row_msg: (name, text, type='danger') ->
    msg = @$el.find(".form-tip[for=\"#{name}\"]")
    row = @$el.find(".form-group[for=\"#{name}\"]")
    if text
      text = @t(text)
      msg.attr('class', "form-tip text-#{type}").html(text).show()
      if type == 'danger'
        row.addClass('has-error').find("[name=\"#{name}\"]")
        .one 'blur', =>
          @row_msg(name)
    else
      row.removeClass('has-error')
      msg.attr('class', 'form-tip').html('').hide()
  render: ->
    super
    @$form = @$el.find('form')
  submit: (e) ->
    e.preventDefault()
    @disable()
  disable: (e) ->
    @$form.find('[type=submit]').attr('disabled', true)
  enable: (e) ->
    @$form.find('[type=submit]').removeAttr('disabled')
  events:
    'submit form': 'submit'
