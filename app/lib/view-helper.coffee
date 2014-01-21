# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
consts = require 'consts'
utils = require './utils'

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Map helpers
# -----------

# Make 'with' behave a little more mustachey.
register 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
register 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  utils.reverse routeName, params

# translate text
register 't', (i18n_key, args..., options) ->
  result = $.i18n._(i18n_key, args...)
  if i18n_key not of $.i18n.dict
    console.warn "Please translate [#{i18n_key}] !"
  new Handlebars.SafeString(result)

# include template
register '>', (tmpl, options) ->
  (require tmpl)(options)


exports.globals =
  consts: consts
  mediator: Chaplin.mediator
  site_url: consts.SITE_ROOT + '/'
