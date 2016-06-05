ready = ->
  $('form [name="render"]').click (e)->
    e.preventDefault()
    $('#post_preview_text').html(getPreview())

  if ace?
    textarea = $('#post_text')
    window.editor = ace.edit('post_text_editor')
    editor.getSession().setTabSize(2)
    editor.getSession().setUseSoftTabs(true)
    setText(textarea.val())
    editor.getSession().on 'change', ->
      textarea.val(getText())
    editor.getSession().setMode('ace/mode/markdown')

getPreview = ->
  $.ajax('/blog/posts/preview', data: { post: { text: getText()}}, async: false).responseText

getText = ->
  console.log editor.getSession().getValue()
  editor.getSession().getValue()

setText = (text)->
  editor.getSession().setValue(text)

$(document).ready ready
$(document).on 'page:load', ready
