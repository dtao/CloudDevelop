window.CloudDevelop ?= {}

CloudDevelop.showLoading = (container) ->
  container ?= $("body")
  $("<div>").addClass("loading").appendTo(container)

CloudDevelop.removeLoading = (container) ->
  $(".loading").remove()

CloudDevelop.displayError = (msg) ->
  resultContainer = $(".result").empty()
  $("<div>").addClass("error").text(msg).appendTo(resultContainer)

CloudDevelop.displayFlash = (message) ->
  body      = $("body")
  container = $("#flash")

  if container.length == 0 && message?
    container = $("<div id='flash'>").prependTo(body)

  container.html(message) if message?

  container.animate { top: 0 }, 1000, ->
    CloudDevelop.delay 5000, ->
      container.animate { top: -50 }, 1000, ->
        container.remove()

CloudDevelop.delay = (timeout, callback) ->
  setTimeout(callback, timeout)
