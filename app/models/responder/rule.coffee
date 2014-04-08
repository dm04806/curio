Model = require 'models/base/model'

# Reply-rule
module.exports = class Rrule extends Model
  kind: 'rrule'

  defaults:
    type: 'keyword'
    pattern: null
    handler: null

  getType: () ->
    attrs = @attributes
    if attrs.pattern == '$subscribe'
      'subscribe'
    if attrs.pattern == '$any'
      'any'
    'keyword'

  set: ->
    super
    attrs = @attributes
    # default name to pattern
    attrs.name = attrs.name or attrs.pattern

