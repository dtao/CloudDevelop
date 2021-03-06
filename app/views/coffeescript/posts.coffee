window.CloudDevelop ?= {}

$(document).ready ->
  $(".delete").click (e) ->
    return unless confirm("Are you sure you want to delete this post?")

    row   = $(this).closest("tr")
    token = row.data("token")

    ajax = CloudDevelop.ajax
      url: "/#{token}"
      type: "DELETE"
      dataType: "json"

    ajax.done (done) ->
      if done.success
        row.remove()
        CloudDevelop.displayFlash("Successully deleted post '#{token}'.")
      else
        CloudDevelop.displayFlash("Failed to delete post.")

    ajax.fail ->
      CloudDevelop.displayFlash("Failed to delete post.")

    e.preventDefault()
