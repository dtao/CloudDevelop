window.CloudDevelop ?= {}

CloudDevelop.init = (language) ->
  $(document).ready ->
    resultContainer = $(".result")

    $("#clear").click ->
      editor.setValue("") for editor in CloudDevelop.getEditors()

    $("#compile").click ->
      specEditorHtml  = resultContainer.html()
      resultContainer.empty()

      token = CloudDevelop.getToken()

      promise = CloudDevelop.ajax
        container: resultContainer
        url: "/#{token}"
        data:
          language: language
          source:   CloudDevelop.getEditor("source-editor").getValue()
          spec:     CloudDevelop.getEditor("spec-editor").getValue()
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
          source:   CloudDevelop.getEditor("source-editor").getValue()
          spec:     CloudDevelop.getEditor("spec-editor").getValue()
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
      spec = CloudDevelop.getEditor("spec-editor").getValue()
      textarea = $("<textarea>").val(spec).data("mode", CloudDevelop.getEditor("spec-editor").getOption("mode"))
      textarea.appendTo(resultContainer)
      CloudDevelop.initEditor(resultContainer)
