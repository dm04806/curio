Collection = require './collection'

# Base model.
module.exports = class Model extends Chaplin.Model
  list: ->
    new Collection model: this
  # Mixin a synchronization state machine.
  # _(@prototype).extend Chaplin.SyncMachine
  # initialize: ->
  #   super
  #   @on 'request', @beginSync
  #   @on 'sync', @finishSync
  #   @on 'error', @unsync
