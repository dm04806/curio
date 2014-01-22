# global loading status
mediator = require 'mediator'

$(document).ajaxStart (e)->
  $('body').addClass('loading')
.ajaxStop (e)->
  $('body').removeClass('loading')

