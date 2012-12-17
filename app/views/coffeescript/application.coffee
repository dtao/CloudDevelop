window.CloudDevelop ?= {}

editors = {}

mockEditor =
  setValue: ->
  getValue: -> ""

CloudDevelop.initEditor = (container) ->
  $textarea = $(container).find("textarea")
  editorId  = $textarea.attr("id")

  if $textarea.length > 0
    mode   = $textarea.data("mode")
    editor = CodeMirror.fromTextArea $textarea[0],
      mode: mode
    editors[editorId] = editor

  CloudDevelop.getEditor(editorId)

CloudDevelop.getEditor = (id) ->
  editors[id] || mockEditor

CloudDevelop.getEditors = ->
  array = []
  array.push(editor) for id, editor in editors
  array

CloudDevelop.showLoading = (container) ->
  container ?= $("body")
  loadingContainer = $("<div>").addClass("loading").appendTo(container)
  loadingImage = $("<img src='/images/loading.gif'>").appendTo(loadingContainer)

CloudDevelop.removeLoading = (container) ->
  $(".loading").remove()

CloudDevelop.ajax = (options) ->
  CloudDevelop.showLoading(options.container)

  promise = $.ajax(options)

  promise.done (data) ->
    CloudDevelop.displayFlash(data.message) if data.message?

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

CloudDevelop.increment = (element) ->
  value = parseInt(element.text())
  element.text(value + 1)

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

  $(".content").one "click", ->
    $("#instructions").remove()

  # Show a notification, if one is present.
  CloudDevelop.displayFlash()
