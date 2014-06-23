View = require 'views/base/view'
mediator = require 'mediator'

module.exports = class PageView extends View
  optionNames: View::optionNames.concat ['layout']
  container: 'body'
  id: 'site-container'
  layout: 'normal'
  debug: true
  context: ->
    pmwx: mediator.pmwx
  regions:
    header: '#header'
    sidebar: '#sidebar'
    main: '#main'
    footer: '#footer'
  setLayout: (layout) ->
    layout = layout or @layout
    body = $('html')
    cls = body.attr('class') or ''
    tmp = cls.split('layout')
    tmp[1] = "layout-#{layout}"
    cls = $.trim(tmp.join(' '))
    body.attr('class', cls)
  render: ->
    super
    @setLayout()
  template: require "./templates/layout-basic"
