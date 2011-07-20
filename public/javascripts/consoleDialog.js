clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    height: 480,
    width: 640,
    dialogClass: "console",
    buttons: {
      Close: function() {
        $(this).dialog("close");
      }
    }
  };

  clouddevelop.consoleDialog = function(dialogName) {
    return clouddevelop.dialogBase(dialogName, options);
  };
})();