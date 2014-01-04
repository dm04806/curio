Page = require 'views/base/page'

module.exports = class SinglePage extends Page
  regions:
    header: '#header'
    main: '#main'
  template: require './templates/layout-singled'
