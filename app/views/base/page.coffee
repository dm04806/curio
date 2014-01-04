View = require 'views/base/view'

module.exports = class PageView extends View
  el: 'body'
  regions:
    header: '#header'
    sidebar: '#sidebar'
    main: '#main'
  template: require './templates/layout-columned'
