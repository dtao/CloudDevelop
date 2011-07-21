clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: "auto",
    width: "auto"
  };

  clouddevelop.openDialog = function(dialogName, codeEditor, languageSelect) {
    var openDialog = clouddevelop.dialogBase(dialogName, options),
      $dialog = $("#" + dialogName + "-dialog");

    $dialog.dialog("option", "buttons", {
      OK: function() {
        var self = this,
          fileName = $("#open-file-name").val();
        if (fileName === "") {
          return false;
        }

        $dialog.dialog("option", "width", 480);
        $dialog.dialog("option", "height", 360);

        openDialog.showLoading();

        clouddevelop.service.open(fileName)
          .onSuccess(function(result) {
            codeEditor.loadCodeSnippet(languageSelect, result);
            $("#file-info-box").empty().append($("<p>").text(fileName));
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

    openDialog.shrink = function() {
      $dialog.dialog("option", "width", "auto");
      $dialog.dialog("option", "height", "auto");
    };

    return openDialog;
  };
})();