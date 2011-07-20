clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: "auto",
    width: "auto",
    buttons: {
      OK: function() {
        var fileName = $("#new-file-name").val();
        if (fileName === "") {
          return false;
        }
        loadCodeSnippet(codeEditor, languageSelect, null);
        $("#file-info-box").empty().append($("<p>").text(fileName));
        $(this).dialog("close");
      },
      Cancel: function() {
        $(this).dialog("close");
      }
    }
  };

  clouddevelop.newDialog = function(dialogName) {
    return clouddevelop.dialogBase(dialogName, options);
  };
})();