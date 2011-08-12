clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: 360,
    width: 480
  };

  clouddevelop.saveDialog = function($dialog) {
    var saveDialog = clouddevelop.dialogBase($dialog, options),
      snippetSavedHandler = $.noop;
    
    function save(code, language) {
      saveDialog.showLoading();
      saveDialog.show();
      clouddevelop.service.save(code, language)
        .onSuccess(function(result) {
          saveDialog.displayInfo(result.info);
          saveDialog.reveal();
          snippetSavedHandler(result.id, result.codeSnippet);
          showOkButton();
        })
        .onError(function(result) {
          saveDialog.displayInfo(JSON.stringify(result));
          saveDialog.reveal();
          showOkButton();
        });
    }

    function update(id, code) {
      saveDialog.showLoading();
      saveDialog.show();
      clouddevelop.service.update(id, code)
        .onSuccess(function(result) {
          saveDialog.displayInfo(result.info);
          saveDialog.reveal();
          snippetSavedHandler(result.id, result.codeSnippet);
          showOkButton();
        })
        .onError(function(result) {
          saveDialog.displayInfo(JSON.stringify(result));
          saveDialog.reveal();
          showOkButton();
        });
    }

    function showOkButton() {
      $dialog.dialog("option", "buttons", {
        OK: function() {
          saveDialog.hide();
        }
      });
    }

    function hideOkButton() {
      $dialog.dialog("option", "buttons", {});
    }

    function onSnippetSaved(handler) {
      snippetSavedHandler = handler;
    }

    return $.extend(saveDialog, {
      save: save,
      update: update,
      showOkButton: showOkButton,
      hideOkButton: hideOkButton,
      onSnippetSaved: onSnippetSaved
    });
  };
}());