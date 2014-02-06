mediator = module.exports = Chaplin.mediator

# load middlewares
require 'controllers/base/transition'
require 'controllers/base/site-error'
require 'controllers/base/session'

