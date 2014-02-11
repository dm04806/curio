
class CurioError extends Error
  constructor: (@code) ->
  category: 'danger'

Object.defineProperties CurioError.prototype,
  title:
    get: ->
      # Error messages is stored in i18n
      __g("error.#{@code}.title") or __('error.general')
  detail:
    get: ->
      __g("error.#{@code}.detail")

exports.CurioError = CurioError
exports.AccessError = class AccessError extends CurioError
  category: 'warning' # css class="alert-#{category}"
