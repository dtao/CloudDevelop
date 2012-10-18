window.CloudDevelop ?= {}

CloudDevelop.initEditor = ($container) ->
  textarea = $container.find("textarea")[0]
  if textarea?
    mode     = $(textarea).data("mode")
    CodeMirror.fromTextArea textarea,
      mode: mode
  else
    # TODO: Think of a less hacky way of doing this.
    {
      setValue: ->
      getValue: -> ""
    }

CloudDevelop.init = (language) ->
  $(document).ready ->
    editorContainer = $(".editor")
    resultContainer = $(".result")

    CloudDevelop.sourceEditor = CloudDevelop.initEditor(editorContainer)
    CloudDevelop.specEditor   = CloudDevelop.initEditor(resultContainer)

    $("#clear").click ->
      CloudDevelop.sourceEditor.setValue("")
      CloudDevelop.specEditor.setValue("")

    $("#compile").click ->
      specEditorHtml  = resultContainer.html()
      resultContainer.empty()
      CloudDevelop.showLoading(resultContainer)

      token = CloudDevelop.getToken()

      ajax = $.ajax
        url: "/#{token}"
        data:
          language: language
          source:   CloudDevelop.sourceEditor.getValue()
          spec:     CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      ajax.done (data) ->
        resultContainer.empty()

        switch data.action
          when "frame"
            $("<iframe src='#{data.url}'>").appendTo(resultContainer)
          when "render"
            $("<pre class='console'>").text(data.output).appendTo(resultContainer)

        $("<div class='back'>").text("Back").appendTo(resultContainer)

      ajax.fail ->
        CloudDevelop.displayError("Oh noes!")

    $("#save").click ->
      CloudDevelop.showLoading()

      token = CloudDevelop.getToken()

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

    $(".back").live "click", ->
      resultContainer.empty()
      spec = CloudDevelop.specEditor.getValue()
      textarea = $("<textarea>").val(spec).data("mode", CloudDevelop.specEditor.getOption("mode"))
      textarea.appendTo(resultContainer)
      CloudDevelop.specEditor = CloudDevelop.initEditor(resultContainer)

    # All links in captions should open in a new window/tab.
    $(".caption a").attr("target", "_blank")

    $(".dismiss").live "click", (e) ->
      e.preventDefault()
      $(this).parent().remove()

    CloudDevelop.displayFlash()
