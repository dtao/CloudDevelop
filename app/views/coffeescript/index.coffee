window.CloudDevelop ?= {}

CloudDevelop.initEditor = ($container) ->
  textarea = $container.find("textarea")[0]
  mode     = $(textarea).data("mode")
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

        switch data.action
          when "frame"
            $("<iframe src='#{data.url}'>").appendTo(resultContainer)
          when "render"
            $("<pre class='output'>").text(data.output).appendTo(resultContainer)

      ajax.fail ->
        CloudDevelop.displayError("Oh noes!")

    $("#save").click ->
      CloudDevelop.showLoading()

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

    # All links in captions should open in a new window/tab.
    $(".caption a").attr("target", "_blank")

    $(".dismiss").live "click", ->
      $(this).parent().remove()

    CloudDevelop.displayFlash()
