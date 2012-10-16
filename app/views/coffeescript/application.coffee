window.CloudDevelop ?= {}

window.CloudDevelop.init = (language) ->
  $(document).ready ->
    editor = document.getElementById("source-editor")
    CodeMirror.fromTextArea editor,
      mode: language
