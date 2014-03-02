Model = require 'models/base/model'

module.exports = class User extends Model
  kind: 'passport'
  defaults:
    password: null


