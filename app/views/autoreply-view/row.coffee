mediator = require 'mediator'
View = require 'views/base/view'

module.exports = class AutoreplyRuleView extends View
  autoRender: true
  template: require './templates/row'

