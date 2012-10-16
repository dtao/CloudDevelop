window.CloudDevelop ?= {}

window.CloudDevelop.init = (mode) ->
  $(document).ready ->
    editor = document.getElementById("source-editor")
    CodeMirror.fromTextArea editor,
      mode: mode
