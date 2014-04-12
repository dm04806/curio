utils = require 'lib/utils'

##
# Foldable Element
# Global UI plugin, just like bootstrap components
#
# Options:
#
#   `remember`  - save fold status to localStorage
#   `toggler`     - element to toggle fold status
#
class Foldable

  @DEFAULTS:
    remember: true
    fixHeight: true

  constructor: (options) ->
    @$el = $(options.el)
    options = _.assign({}, Foldable.DEFAULTS, @$el.data(), options)
    # global ID to identify fold status
    @id = options.id or getId(@$el)
    @options = options
    @$el.addClass('foldable')
    if options.fixHeight and @$el.height()
      @$el.height(options.height or @$el.height())
    if options.remember
      if @hasFolded() == 0
        @$el.removeClass('folded')
      else if @hasFolded()
        @$el.addClass('folded')
    else if options.fold
      @$el.addClass('folded')
    @updateToggler()
    if options.toggler
      # bind event on toggler
      $(options.toggler).on 'click', (e) =>
        e.preventDefault()
        @toggle()

  toggle: (e) ->
    @$el.toggleClass('folded')
    if @options.remember
      @saveStatus()
    @updateToggler()
    return this

  # update toggler text
  updateToggler: (e) ->
    el = @$el
    node = el.parent().find('.fold-toggler')
    if not node.length
      node = $(".fold-toggler[data-toggle='##{@id}']")
    opts = node.data()
    return if not opts
    if el.hasClass('folded')
      node.html(opts.toExpand)
    else
      node.html(opts.toFold)

  hasFolded: () ->
    # get fold status from storage
    utils.store "fold-flag:#{@id}"

  saveStatus: () ->
    status = @$el.hasClass('folded')
    key = "fold-flag:#{@id}"
    if status
      utils.store key, 1
    else
      utils.store key, 0
    return this


getId = (node) ->
  node.attr('id') or node.data('name') or node.parent().attr('id')


$.fn.foldable = (options) ->
  options = options or {}
  if 'string' == typeof options
    options = { act: options }
  foldable = @data('curio.foldable')
  if not foldable
    options.el = this
    foldable = new Foldable(options)
    @data('curio.foldable', foldable)
  if options.act
    return foldable[options.act]()
  return this


# Delegate global event handler
$(document).on 'click.curio.foldable', '.fold-toggler', (e) ->
  e.preventDefault()
  node = $(this)
  el = $(node.data('toggle'))
  return if not el.length
  el.foldable('toggle')
