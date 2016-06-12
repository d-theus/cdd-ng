#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require material

ready = ->
  $.material.init()

$(document).on 'page:load', ready
$(document).ready ready
