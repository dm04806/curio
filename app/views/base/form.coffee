MainView = require './main'
utils = require 'lib/utils'

module.exports = class EditModelView extends MainView
  msg: (text, type='danger', expires) ->
    text = __g(text) or __(text.replace "_#{@model?.kind}", '')
    msg = @$el.find('.form-message')
      .html("<div class=\"alert alert-#{type}\">#{text}</div>")
    if expires
      alert = @$alert = msg.find('.alert')
        .delay(1200) # show message for 1.2s
         # start a fadeOutDown with duration 400ms
        .anim('fadeOutDown', 400, 200)
         # then start slideUp in 200ms
        .slideUp(300)
      alert.promise().done =>
        # when all animation is done, remove this alert
        alert.remove()
        @$alert = null
    return msg
  render: ->
    super
    @$form = @$el.find('form')
  submit: (e) ->
    @disable()
  disable: (e) ->
    @$form.find('[type=submit]').attr('disabled', true)
  enable: (e) ->
    @$form.find('[type=submit]').removeAttr('disabled')
  events:
    'submit form': 'submit'

