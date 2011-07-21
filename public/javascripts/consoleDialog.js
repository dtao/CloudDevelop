clouddevelop = clouddevelop || {};

(function() {
  var options = {
    autoOpen: false,
    modal: true,
    width: 640,
    height: 480,
    dialogClass: "console",
    buttons: {
      Close: function() {
        $(this).dialog("close");
      }
    }
  };

  clouddevelop.consoleDialog = function($dialog) {
    var consoleDialog = clouddevelop.dialogBase($dialog, options),
      $info = $dialog.find(".info"),
      $output = $dialog.find(".output");

    function display(info, output, isError) {
      if (isError) {
        $info.addClass("error");
      } else {
        $info.removeClass("error");
      }
      
      $info.text(info || "");
      $output.text(output || "No output");
    }

    return $.extend(consoleDialog, {
      display: display
    });
  };
})();