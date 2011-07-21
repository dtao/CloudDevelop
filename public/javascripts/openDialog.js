clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: "auto",
    width: "auto"
  };

  clouddevelop.openDialog = function($dialog) {
    var openDialog = clouddevelop.dialogBase($dialog, options),
      snippetLoadedHandler = $.noop;

    $dialog.dialog("option", "buttons", {
      OK: function() {
        var self = this,
          snippetId = $dialog.find(".snippet-id").val();
        
        if (snippetId === "") {
          return false;
        }

        $dialog.dialog("option", "width", 480);
        $dialog.dialog("option", "height", 360);

        openDialog.showLoading();

        clouddevelop.service.open(snippetId)
          .onSuccess(function(result) {
            snippetLoadedHandler(snippetId, result);
            openDialog.hide();
          })
          .onError(function(result) {
            openDialog.reveal();
            alert(result);
          });
      },
      Cancel: function() {
        openDialog.hide();
      }
    });

    function clear() {
      $dialog.find("input").val("");
    }

    function shrink() {
      $dialog.dialog("option", "width", "auto");
      $dialog.dialog("option", "height", "auto");
    };

    function onSnippetLoaded(handler) {
      snippetLoadedHandler = handler;
    }

    return $.extend(openDialog, {
      clear: clear,
      shrink: shrink,
      onSnippetLoaded: onSnippetLoaded
    });
  };
})();