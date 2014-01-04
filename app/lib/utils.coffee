# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

readymark = {}
onreadies = {}

_.extend utils,
  fireReady: (name, val) ->
    readymark[name].loaded = true
    fn(null, val) for fn in onreadies[name]
  getReady: (name) ->
    readymark[name] = false
    waitlist = onreadies[name] ? []
    onreadies[name] = waitlist
    return (callback) ->
      if readymark[name]
        callback()
      else
        waitlist.push callback

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
