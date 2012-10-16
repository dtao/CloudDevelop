window.CloudDevelop ?= parent.CloudDevelop

$(document).ready ->
  $("a.back-link").click (e) ->
    ajax = $.ajax
      url: $(this).attr("href")
      type: "GET",
      dataType: "html"

    ajax.done (html) ->
      $result = parent.$(".result")
      $result.html(html)
      CloudDevelop.specEditor = CloudDevelop.initEditor($result)

    ajax.fail ->
      CloudDevelop.displayError("Oh crap!")

    e.preventDefault()
