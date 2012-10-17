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
      CloudDevelop.showLoading($(".result").empty())

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
      CloudDevelop.showLoading()

      ajax = $.ajax
        url: "/save"
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

CloudDevelop.showLoading = (container) ->
  container ?= $("body")
  $("<div>").addClass("loading").appendTo(container)

CloudDevelop.displayError = (msg) ->
  resultContainer = $(".result").empty()
  $("<div>").addClass("error").text(msg).appendTo(resultContainer)
