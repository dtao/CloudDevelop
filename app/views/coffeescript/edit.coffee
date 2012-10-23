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

      token = CloudDevelop.getToken()

      promise = CloudDevelop.ajax
        container: resultContainer
        url: "/#{token}"
        data:
          language: language
          source:   CloudDevelop.sourceEditor.getValue()
          spec:     CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      promise.done (data) ->
        resultContainer.empty()

        switch data.action
          when "frame"
            $("<iframe src='#{data.url}'>").appendTo(resultContainer)
          when "render"
            $("<pre class='console'>").text(data.output).appendTo(resultContainer)

        $("<div class='back'>").text("Back").appendTo(resultContainer)

    $("#save").click ->
      if $(this).is(".disabled")
        CloudDevelop.displayError("You aren't allowed to update this post.")
        return

      token = CloudDevelop.getToken()

      promise = CloudDevelop.ajax
        url: "/save/#{token}"
        data:
          label:    CloudDevelop.getLabel()
          language: language
          source:   CloudDevelop.sourceEditor.getValue()
          spec:     CloudDevelop.specEditor.getValue()
        type: "POST"
        dataType: "json"

      promise.done (data) ->
        window.location = "/#{data.token}"

    $(".upvote").click (e) ->
      element = $(this)

      token = CloudDevelop.getToken()

      promise = CloudDevelop.ajax
        url: "/upvote/#{token}"
        type: "POST"
        dataType: "json"

      promise.done (data) ->
        element.find(".vote").remove()
        CloudDevelop.increment(element.find(".count"))

    $(".back").live "click", ->
      resultContainer.empty()
      spec = CloudDevelop.specEditor.getValue()
      textarea = $("<textarea>").val(spec).data("mode", CloudDevelop.specEditor.getOption("mode"))
      textarea.appendTo(resultContainer)
      CloudDevelop.specEditor = CloudDevelop.initEditor(resultContainer)
