# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

_.extend utils,
  # collect client side error
  error: console.error.bind(console)
  debug: console.debug.bind(console)
  store: (item, value) ->
    if not value
      return localStorage.setItem(item, JSON.stringify(value))
    try
      value = JSON.parse(localStorage.getItem(item))
    catch error
      utils.debug '[curio store]', error
      localStorage.setItem(item, '')
    return value

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
