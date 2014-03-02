View = require 'views/base/view'
utils = require 'lib/utils'

module.exports = class FormView extends View
  autoRender: true
  render: ->
    super
    @$form = @$el.find('form')

  t: (text) ->
    # will fallback to none model specified message
    # so you can set error in messages.yaml like this:
    #
    #   edit_user:
    #     name:
    #       is blank: 用户名不能为空
    #
    #   edit:
    #     name:
    #       is blank: 名称不能为空
    #
    __g(text) or __(text.replace "_#{@model?.kind}", '')


  #
  #  Show global form message
  #
  #  form > .form-message
  #
  msg: (text, type='danger', expires='flash') ->
    if not text
      @$el.find('.form-message').html('')
      return
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

  #
  # Show message per row, given the HTML structure:
  #
  #  form > .form-group > .form-tip
  #
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

  clearErrors: ->
    @$el.find('.has-error').removeClass('has-error')
    @$el.find('.form-message').text('')

  submit: (e) ->
    e.preventDefault()
    @clearErrors()
    @disable()

  disable: (e) ->
    @$el.find('[type=submit]').attr('disabled', true)

  enable: (e) ->
    @$el?.find('[type=submit]').removeAttr('disabled')

  events:
    'submit form': 'submit'

