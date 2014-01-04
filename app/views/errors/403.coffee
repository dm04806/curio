View = require 'views/base'

module.exports = class PermissionDeniedView extends View
  className: 'error'
  template: require './templates/403'
