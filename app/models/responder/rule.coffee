Model = require 'models/base/model'

# Reply-rule
module.exports = class Rrule extends Model
  kind: 'rrule'

  defaults:
    type: 'text'
    pattern: null
    handler: null
