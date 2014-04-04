Model = require 'models/base/model'

# Reply-rule
module.exports = class Rrule extends Model
  defaults:
    type: 'text'
    pattern: null
    handler: null
