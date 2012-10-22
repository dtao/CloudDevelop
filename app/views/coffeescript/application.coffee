window.CloudDevelop ?= {}

CloudDevelop.showLoading = (container) ->
  container ?= $("body")
  loadingContainer = $("<div>").addClass("loading").appendTo(container)
  loadingImage = $("<img src='/images/loading.gif'>").appendTo(loadingContainer)

CloudDevelop.removeLoading = (container) ->
  $(".loading").remove()

CloudDevelop.ajax = (options) ->
  CloudDevelop.showLoading(options.container)

  promise = $.ajax(options)

  promise.fail ->
    CloudDevelop.displayError("An unexpected error occurred. <a href='mailto:daniel.tao@gmail.com'>E-mail me</a> and let me know what happened!")

  promise.always ->
    CloudDevelop.removeLoading()

  promise

CloudDevelop.displayFlash = (message, attributes) ->
  body      = $("body")
  container = $("#flash")

  if container.length == 0 && message?
    container = $("<div id='flash'>")

    if attributes?
      container.css(name, value) for name, value of attributes
    container.prependTo(body)

  if message?
    container.empty()
    dismissLink = $("<a href='javascript:void(0);' class='dismiss'>").html("&times;").appendTo(container)
    container.append(message)

  container.animate { top: 0 }, 1000, ->
    CloudDevelop.delay 5000, ->
      container.animate { top: -50 }, 1000, ->
        container.remove()

CloudDevelop.displayError = (msg) ->
  CloudDevelop.displayFlash msg,
    class: "error"

CloudDevelop.delay = (timeout, callback) ->
  setTimeout(callback, timeout)

CloudDevelop.getLabel = ->
  $("#label-input").val()

CloudDevelop.getToken = ->
  $("#token").val()

$(document).ready ->
  # All links in instructional text should open in a new window/tab.
  $("#instructions a").attr("target", "_blank")

  # Any element with the class "dismiss" will remove its container.
  $(".dismiss").live "click", (e) ->
    link = $(this)
    e.preventDefault()
    if link.data("dismiss")
      dismissSelector = link.data("dismiss")
      $(dismissSelector).remove()
    else
      link.parent().remove()

  # Show a notification, if one is present.
  CloudDevelop.displayFlash()
