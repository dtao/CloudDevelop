window.CloudDevelop ?= {}

window.CloudDevelop.init = (mode) ->
  $(document).ready ->
    sourceEditor = document.getElementById("source-editor")
    CodeMirror.fromTextArea sourceEditor,
      mode: mode

    specEditor = document.getElementById("spec-editor")
    CodeMirror.fromTextArea specEditor,
      mode: mode
