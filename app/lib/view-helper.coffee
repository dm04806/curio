# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------
consts = require 'consts'
utils = require './utils'
i18n = require 'lib/i18n'
moment = require 'lib/moment'
maplib = require 'lib/map'

_.assign consts, require 'models/consts'

SafeString = Handlebars.SafeString

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# translate text
register 't', (i18n_key, args..., options) ->
  return unless i18n_key
  if i18n_key instanceof SafeString
    # already translated
    return i18n_key
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

register 'not', (val) ->
  return !val

register 'compare', (args..., options) ->
  if not args.length
    throw new Error('Handlerbars Helper "compare" needs at least one parameter')
  if args.length == 1
    operator = 'truesy'
  [left, operator, right] = args
  if right is undefined
    right = operator
    operator = '==='

  operators = `{
    '==':     function(l, r) {return l == r },
    '===':    function(l, r) {return l === r },
    '!=':     function(l, r) {return l != r },
    '!==':    function(l, r) {return l !== r },
    '<':      function(l, r) {return l < r },
    '>':      function(l, r) {return l > r },
    '<=':     function(l, r) {return l <= r },
    '>=':     function(l, r) {return l >= r },
    'typeof': function(l, r) {return typeof l == r },
    'truesy': function(l) { return Boolean(l) }
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
  #console.log obj
  return JSON.stringify obj, null, 4

register 'debug', (obj) ->
  console.debug obj

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
  data = options.hash
  data.__proto__ = this
  if 'string' is typeof tmpl
    ret = (require tmpl)(data)
  if 'function' is typeof tmpl
    ret = tmpl data
  new SafeString(ret)


register "form_rows", (size, args..., options) ->
  col1 = args[0]
  col2 = args[1] or (12 - col1)
  this.label_cls = "col-#{size}-#{col1}"
  this.row_cls = "col-#{size}-#{col2}"
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

    attrs = ("#{k}=\"#{v ? ''}\"" for k, v of attrs when v).join(' ')
    data =
      name: name
      attrs: attrs
      value: value
      tip: tip
      label: __(label)
      label_cls: @label_cls
      row_cls: @row_cls
    new SafeString tmpl data


# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  utils.reverse routeName, params


# get model attributes
register 'attr', (names..., options) ->
  for name in names
    val = this.get?(name) or _.result(this, name)
    return val if val? && val isnt ''
  return val

register 'btrunc', (opts..., options) ->
  return utils.btrunc.apply(this, opts)

# Content formating helpers
register 'strftime', (format, date, options) ->
  if isNaN(date) and options.hash.showInvalid
    return __('unknown time')
  if format == 'locale'
    return date.toLocaleString()
  if format == 'fromnow'
    return moment(date).fromNow()
  if format == 'MMM Do' and i18n.locale == 'zh-cn'
    format = 'MMMDo'
  return moment(date).format(format)

# Map Static img url
register 'mapImg', (lat, lng, args..., options) ->
  size = args[0] || '340*120'
  zoom = args[1] || 15
  "http://restapi.amap.com/v3/staticmap?size=#{size}&markers=mid,,:#{lng},#{lat}&zoom=#{zoom}&key=#{consts.AMAP_AK}"
  #"http://st.map.qq.com/api?size=#{size}&markers=#{lng},#{lat}&zoom=#{zoom}"

register 'gmapImg', (lat, lng, args..., optins) ->
  maplib.gstaticMap
    lat: lat
    lng: lng
    size: args[0] || '340*120'
    zoom: args[1] || 15


exports.globals =
  consts: consts
  mediator: Chaplin.mediator
  site_url: consts.SITE_ROOT + '/'
