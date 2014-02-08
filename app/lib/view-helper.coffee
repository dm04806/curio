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
  return unless i18n_key
  if i18n_key not of $.i18n.dict
    console.warn "Please translate [#{i18n_key}] !"
  result = __(i18n_key, args...)
  new Handlebars.SafeString(result)

# include template
register 'include', (tmpl, options) ->
  ret = ''
  if 'string' is typeof tmpl
    ret = (require tmpl)(this)
  if 'function' is typeof tmpl
    ret = tmpl this
  new Handlebars.SafeString(ret)


register "form_rows", (size, col, options) ->
  this.label_cls = "col-#{size}-#{col}"
  this.row_cls = "col-#{size}-#{12 - col}"
  return options.fn(this)

# form control helpers
['input', 'textarea'].forEach (widget) ->
  register "form_#{widget}", (name, args..., options) ->
    tmpl = require "views/widgets/templates/form/#{widget}_row"
    [value, label, placeholder] = args
    left_col = left_col or 2
    # handle some default value
    if label is undefined
      label = name
    if placeholder is undefined and not label
      placeholder = name
    _.assign this,
      name: name
      value: value
      label: label
      placeholder: placeholder
    new Handlebars.SafeString tmpl this

exports.globals =
  consts: consts
  mediator: Chaplin.mediator
  site_url: consts.SITE_ROOT + '/'
