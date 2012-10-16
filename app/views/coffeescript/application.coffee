window.CloudDevelop ?= {}

CloudDevelop.initEditor = ($container) ->
  textarea   = $container.find("textarea")[0]
  mode       = $(textarea).data("mode")
  CodeMirror.fromTextArea textarea,
    mode: mode

CloudDevelop.init = (mode) ->
  $(document).ready ->
    CloudDevelop.sourceEditor = CloudDevelop.initEditor($(".editor"))
    CloudDevelop.specEditor   = CloudDevelop.initEditor($(".result"))

    $("#compile").click ->
      ajax = $.ajax
        url: window.location
        data:
          source: CloudDevelop.sourceEditor.getValue()
          spec: CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      ajax.done (data) ->
        resultContainer = $(".result").empty()
        frame = $("<iframe src='/result/#{data.id}'>").appendTo(resultContainer)

      ajax.fail ->
        CloudDevelop.displayError("Oh noes!")

CloudDevelop.displayError = (msg) ->
  alert(msg)
