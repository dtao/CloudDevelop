window.CloudDevelop ?= {}

$(document).ready ->
  $(".delete").click (e) ->
    row   = $(this).closest("tr")
    token = row.data("token")

    CloudDevelop.showLoading()

    ajax = $.ajax
      url: "/#{token}"
      type: "DELETE"
      dataType: "json"

    ajax.done (done) ->
      if done.success
        row.remove();
        CloudDevelop.displayFlash("Successully deleted post '#{token}'.")
      else
        CloudDevelop.displayFlash("Failed to delete post.")

    ajax.fail ->
      CloudDevelop.displayFlash("Failed to delete post.")

    ajax.always ->
      CloudDevelop.removeLoading()

    e.preventDefault()
