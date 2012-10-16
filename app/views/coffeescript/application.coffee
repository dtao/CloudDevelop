window.CloudDevelop ?= {}

CloudDevelop.init = (mode) ->
  $(document).ready ->
    sourceEditor = CodeMirror.fromTextArea document.getElementById("source-editor"),
      mode: mode

    specEditor = CodeMirror.fromTextArea document.getElementById("spec-editor"),
      mode: mode

    $("#compile").click ->
      ajax = $.ajax
        url: window.location
        data:
          source: sourceEditor.getValue()
          spec: specEditor.getValue()
        type: "POST"
        dataType: "json"

      ajax.done (data) ->
        resultContainer = $(".result").empty()
        frame = $("<iframe src='/result/#{data.id}'>").appendTo(resultContainer)

      ajax.fail ->
        CloudDevelop.displayError("Oh noes!")

CloudDevelop.displayError = (msg) ->
  alert(msg)
