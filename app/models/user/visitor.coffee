User = require('./index')

module.exports = class Visitor extends User

  initialize: () ->
    super
    @set
      '_id': null
      'name': __('anonymous')
