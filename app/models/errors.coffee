
class CurioError extends Error
  constructor: (@code) ->
  category: 'danger'
  toJSON: ->
    code: @code
    title: @title
    detail: @detail
    category: @category

Object.defineProperties CurioError.prototype,
  title:
    get: ->
      # Error messages is stored in i18n
      __g("error.#{@code}.title") or __('error.general')
  detail:
    get: ->
      __g("error.#{@code}.detail")

exports.CurioError = CurioError

exports.RetriableError = class RetriableError extends CurioError
  constructor: (@code) ->
  retry: null
  resolver: (view) ->
    return unless @retry
    check = =>
      @retry().done (res) ->
        if res
          view.resolve()
        else
          # no res means server error
          setTimeout check, 10000
      .error ->
        # request error is more like connection problem
        setTimeout check, 5000
    setTimeout check, 5000


exports.AccessError = class AccessError extends CurioError
  category: 'warning' # css class="alert-#{category}"
