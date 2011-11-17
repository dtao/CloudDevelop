clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.dialogBase = function($dialog, options) {
    var $loadingContainer = $dialog.find(".loading-container"),
      $contentContainer = $dialog.find(".content-container"),
      $info = $contentContainer.find(".info");
    
    $dialog.dialog(options);

    function show() {
      $dialog.dialog("open");
    }

    function hide() {
      $dialog.dialog("close");
    }

    function showLoading() {
      $loadingContainer.show();
      $contentContainer.hide();
    }

    function reveal() {
      $loadingContainer.hide();
      $contentContainer.show();
    }

    function displayInfo(info) {
      $info.text(info || "");
    }

    return {
      show: show,
      hide: hide,
      showLoading: showLoading,
      reveal: reveal,
      displayInfo: displayInfo
    };
  };
}());