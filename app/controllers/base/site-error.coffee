mediator = require 'mediator'

mediator.subscribe 'site-error', ()->
  console.log arguments

mediator.subscribe 'site-error:resolve', ()->
