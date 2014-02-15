# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
consts = require 'consts'
utils = require './utils'
i18n = require 'lib/i18n'
moment = require 'lib/moment'

_.assign consts, require 'models/consts'

SafeString = Handlebars.SafeString

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# translate text
register 't', (i18n_key, args..., options) ->
  return unless i18n_key
  if i18n_key not of i18n.dict
    console.warn "Please translate [#{i18n_key}] !"
  result = __(i18n_key, args...)
  new SafeString(result)

register 'g', (i18n_key, args..., options) ->
  return unless i18n_key
  args = args.map (item) ->
    return item ? ''
  result = __g(i18n_key, args...)
  new SafeString(result) if result

register 'when', (bool, vals..., options) ->
  if bool then vals[0] else vals[1]

register 'unless_false', (bool, vals..., options) ->
  if bool is false then vals[1] else vals[0]

register 'any', (vals..., options) ->
  _.find(vals)

register 'compare', (args..., options) ->
  if args.length < 2
    throw new Error('Handlerbars Helper "compare" needs 2 parameters')
  [left, operator, right] = args
  if right is undefined
    right = operator
    operator = '==='

  operators = `{
    '==':     function(l, r) {return l == r; },
    '===':    function(l, r) {return l === r; },
    '!=':     function(l, r) {return l != r; },
    '!==':    function(l, r) {return l !== r; },
    '<':      function(l, r) {return l < r; },
    '>':      function(l, r) {return l > r; },
    '<=':     function(l, r) {return l <= r; },
    '>=':     function(l, r) {return l >= r; },
    'typeof': function(l, r) {return typeof l == r; }
  }`

  if not operators[operator]
    throw new Error('don\'t know how to "compare": ' + operator)

  result = operators[operator](left, right)

  if result
    return options.fn(this)
  else
    return options.inverse(this)

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

register 'json', (obj, options) ->
  console.log obj
  return JSON.stringify obj

register 'widget', (tmpl, options) ->
  tmpl = require "views/widgets/templates/#{tmpl}"
  data = options.hash
  data.caller = options.fn?(this) or ''
  data.__proto__ = this
  new SafeString tmpl data

# update context with a caller
register 'set', (name, value, options) ->
  if options is undefined
    options = value
    value = options.fn
  if 'function' is typeof value
    value = value(this)
  # extend the context
  this[name] = new SafeString value
  return

# include template
register 'include', (tmpl, options) ->
  ret = ''
  if 'string' is typeof tmpl
    ret = (require tmpl)(this)
  if 'function' is typeof tmpl
    ret = tmpl this
  new SafeString(ret)


register "form_rows", (size, col, options) ->
  this.label_cls = "col-#{size}-#{col}"
  this.row_cls = "col-#{size}-#{12 - col}"
  return options.fn(this)

# form control helpers
['input', 'textarea'].forEach (widget) ->
  register "form_#{widget}", (name, args..., options) ->
    hash = options.hash
    tmpl = require "views/widgets/templates/form/#{widget}_row"
    [value, label, placeholder, attrs] = args
    # handle some default value
    if label is undefined
      label = name
    if placeholder is undefined
      placeholder = if label then "#{label}_tip" else name

    tip = hash.tip
    delete hash.tip

    attrs = _.defaults hash,
      class: "form-control input-#{name}"
      name: name
      value: value
      placeholder: __g(placeholder)

    attrs = ("#{k}=\"#{v ? ''}\"" for k, v of attrs).join(' ')
    data =
      name: name
      attrs: attrs
      tip: tip
      label: __(label)
      label_cls: @label_cls
      row_cls: @row_cls
    new SafeString tmpl data

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  utils.reverse routeName, params

# Content formating helpers
register 'strftime', (date, format, options) ->
  if format == 'locale'
    return date.toLocaleString()
  return moment(date).format(format)

# get model attributes
register 'attr', (name) ->
  val = this[name]
  val = this.get?(name) or this[name]
  if 'function' is typeof val
    val = val.call(this)
  return val

exports.globals =
  consts: consts
  locale: i18n.locale
  locale_text: consts.LOCALES[i18n.locale]
  mediator: Chaplin.mediator
  site_url: consts.SITE_ROOT + '/'
