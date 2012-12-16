window.CloudDevelop ?= {}

$(document).ready ->
  $("#save").click ->
    promise = CloudDevelop.ajax
      url: "/save/challenge"
      data:
        label:       $("#label").val()
        description: CloudDevelop.getEditor("description").getValue()

    promise.done (data) ->
      window.location = data.url
