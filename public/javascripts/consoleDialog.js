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
      $info.text(info);
      $output.text(output);
    }

    return $.extend(consoleDialog, {
      display: display
    });
  };
})();