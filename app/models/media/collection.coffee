Collection = require 'models/base/collection'
Media = require './index'
mediator = require 'mediator'
utils =  require 'lib/utils'

session = require 'models/session'

module.exports = class MediaCollection extends Collection
  model: Media
