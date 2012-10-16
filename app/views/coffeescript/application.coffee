window.CloudDevelop ?= {}

CloudDevelop.initEditor = ($container) ->
  textarea   = $container.find("textarea")[0]
  mode       = $(textarea).data("mode")
  CodeMirror.fromTextArea textarea,
    mode: mode

CloudDevelop.init = (language) ->
  $(document).ready ->
    CloudDevelop.sourceEditor = CloudDevelop.initEditor($(".editor"))
    CloudDevelop.specEditor   = CloudDevelop.initEditor($(".result"))

    $("#clear").click ->
      CloudDevelop.sourceEditor.setValue("")
      CloudDevelop.specEditor.setValue("")

    $("#compile").click ->
      ajax = $.ajax
        url: "/"
        data:
          language: language
          source:   CloudDevelop.sourceEditor.getValue()
          spec:     CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      ajax.done (data) ->
        resultContainer = $(".result").empty()
        frame = $("<iframe src='/result/#{data.id}'>").appendTo(resultContainer)

      ajax.fail ->
        CloudDevelop.displayError("Oh noes!")

    $("#save").click ->
      token = window.location.pathname.split("/").pop()

      ajax = $.ajax
        url: "/save/#{token}"
        data:
          language: language
          source:   CloudDevelop.sourceEditor.getValue()
          spec:     CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      ajax.done (data) ->
        window.location = "/#{data.token}"

      ajax.fail ->
        CloudDevelop.displayError("Blast!")

CloudDevelop.displayError = (msg) ->
  alert(msg)
