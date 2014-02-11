# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
consts = require 'consts'
utils = require './utils'
i18n = require 'lib/i18n'
moment = require 'lib/moment'

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Map helpers
# -----------

register 'when', (bool, vals..., options) ->
  return if bool then vals[0] else vals[1]

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

register 'json', (obj, options) ->
  console.log obj
  return JSON.stringify obj

register 'widget', (tmpl, options) ->
  tmpl = require "views/widgets/templates/#{tmpl}"
  data = _.assign options.data, options.hash
  new Handlebars.SafeString tmpl data

# translate text
register 't', (i18n_key, args..., options) ->
  return unless i18n_key
  if i18n_key not of i18n.dict
    console.warn "Please translate [#{i18n_key}] !"
  result = __(i18n_key, args...)
  new Handlebars.SafeString(result)

register 'g', (i18n_key, args..., options) ->
  return unless i18n_key
  result = __g(i18n_key, args...)
  new Handlebars.SafeString(result) if result

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
    [value, label, placeholder, attrs] = args
    # handle some default value
    if label is undefined
      label = name
    if placeholder is undefined
      placeholder = if label then "#{name}_tip" else name
    data =
      name: name
      value: value
      label: label
      placeholder: placeholder
      attrs: attrs
      label_cls: @label_cls
      row_cls: @row_cls
    new Handlebars.SafeString tmpl data



# Content formating helpers
register 'strftime', (date, format, options) ->
  if format == 'locale'
    return date.toLocaleString()
  return moment(date).format(format)

exports.globals =
  consts: consts
  locale: i18n.locale
  locale_text: consts.LOCALES[i18n.locale]
  mediator: Chaplin.mediator
  site_url: consts.SITE_ROOT + '/'
