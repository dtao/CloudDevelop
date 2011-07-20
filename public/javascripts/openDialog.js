clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: "auto",
    width: "auto",
    buttons: {
      OK: function() {
        var self = this,
          fileName = $("#open-file-name").val();
        if (fileName === "") {
          return false;
        }

        clouddevelop.service.open(fileName)
          .onSuccess(function(result) {
            loadCodeSnippet(codeEditor, languageSelect, result);
            $("#file-info-box").empty().append($("<p>").text(fileName));
            $(self).dialog("close");
          })
          .onError(function(result) {
            alert(result);
          });
      },
      Cancel: function() {
        $(this).dialog("close");
      }
    }
  };

  clouddevelop.openDialog = function(dialogName) {
    return clouddevelop.dialogBase(dialogName, options);
  };
})();