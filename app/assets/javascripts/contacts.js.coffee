ready = ->
  $('a[name="mark_as_read"]').on 'ajax:success', ->
    $(this).addClass('disabled')
    $(this).closest('li').find('.label').remove()

  $('a[name="delete"]').on 'ajax:success', ->
    $(this).closest('li').remove()

$(document).on 'page:load', ready
$(document).ready ready
