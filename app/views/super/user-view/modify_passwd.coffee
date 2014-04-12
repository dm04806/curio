EditFormModal = require 'views/common/edit_form_modal'

module.exports = class ModifyPasswd extends EditFormModal
  template: require './templates/modify_passwd'

  row_msg: (name, msg, type) ->
    # we just dont need row message on this simple form
    @msg msg, type

  validates:
    password: (elem) ->
      passwd = @$el.find('input[name=password]').val() or ''
      passwd2 = @$el.find('input[name=password2]').val() or ''
      if not passwd
        return 'edit_passport.password.is blank'
      if passwd.length < 6
        return 'edit_passport.password.too short'
      if passwd != passwd2
        return 'edit_passport.password.missmatch'

  render: ->
    super
    setTimeout =>
      @$el.find('input').eq(0).focus()
    , 200

  events:
    'change input': -> @msg('')
