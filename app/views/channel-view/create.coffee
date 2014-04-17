FormModalView = require 'views/common/form_modal'

module.exports = class CreateChannel extends FormModalView
  template: require './templates/create'
  toConfirm: (e) ->


