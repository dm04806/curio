View = require 'views/base'
utils = require 'lib/utils'

DEFAULTS =
  jumpStart: true
  jumpEnd: true
  showPrev: true
  showNext: true
  wing: 3

module.exports = class PaginatorView extends View
  autoRender: true
  optionNames: View::optionNames.concat ['route'], Object.keys(DEFAULTS)
  template: require './templates/paginator'
  className: 'paginator'
  #debug: true
  context: ->
    pages = @getPages()
    _.assign @getOptions(),
      is_first: @isFirst()
      is_last: @isLast()
      prev_url: @prevUrl()
      next_url: @nextUrl()
      first_url: pages[0]?.url
      last_url: pages[pages.length-1]?.url
      pages: pages

  setOptions: (opts) ->
    _.assign(this, opts)

  getOptions: ->
    ret = {}
    for k of DEFAULTS
      ret[k] = if k of this then this[k] else DEFAULTS[k]
    ret

  isFirst: ->
    not @collection.params.offset

  isLast: ->
    p = @collection.params
    p.offset + p.limit >= @collection.total

  getUrl: (page) ->
    return if not page
    limit = @collection.params.limit
    offset = limit * (page - 1)
    return if offset > @collection.total
    url = if @route then utils.reverse @route else location.pathname
    utils.makeurl url,
      offset: offset or undefined
      limit: if limit == @collection.PERPAGE then undefined else limit

  prevUrl: ->
    @getUrl(@current() - 1)

  nextUrl: ->
    @getUrl(@current() + 1)

  current: ->
    p = @collection.params
    Math.floor(p.offset / p.limit) + 1

  isCurrent: (n) ->
    return n == @current()

  getPages: () ->
    opts = @getOptions()
    total = @collection.total
    limit = @collection.params.limit
    idx = 0
    n = 0
    left_wing = 0
    right_wing = 0
    current = @current()
    pages = []
    while idx < total
      idx += limit
      n += 1
      is_current = n == current
      abs = Math.abs(n - current)
      if abs > opts.wing
        if n == 1 and opts.jumpStart
          # show first page
        else if idx > total and opts.jumpEnd
          # show last page
        else
          if abs - opts.wing == 1
            # show '...'
            pages.push
              text: '...'
          continue
      else if n < current
        if left_wing <= opts.wing
          left_wing += 1
        else
          continue
      else if n > current
        if right_wing <= opts.wing
          right_wing += 1
        else
          # not reaching end
          continue

      pages.push
        url: @getUrl(n)
        text: n
        is_current: is_current
    pages

  render: ->
    return unless @collection.total
    super

  listen:
    'synced collection': 'render'

