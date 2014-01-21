View = require 'views/base'

module.exports = class SiteErrorMain extends View
  className: ->
    "error error-#{@status}"
  optionName: View::optionsName.concat ['error', 'status']
  template: ->
    require "./templates/#{@status}"
  context: ->
    @error

