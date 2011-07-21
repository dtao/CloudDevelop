clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: "auto",
    width: "auto"
  };

  clouddevelop.newDialog = function(dialogName, codeEditor, languageSelect) {
    var newDialog = clouddevelop.dialogBase(dialogName, options),
      $dialog = $("#" + dialogName + "-dialog");

    $dialog.dialog("option", "buttons", {
      OK: function() {
        var fileName = $("#new-file-name").val();
        if (fileName === "") {
          return false;
        }
        codeEditor.loadCodeSnippet(languageSelect, null);
        $("#file-info-box").empty().append($("<p>").text(fileName));
        newDialog.hide();
      },
      Cancel: function() {
        newDialog.hide();
      }
    });

    return newDialog;
  };
})();