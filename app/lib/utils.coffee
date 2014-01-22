# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

_.extend utils,
  # collect client side error
  error: console.error.bind(console)
  debug: console.debug.bind(console)

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
