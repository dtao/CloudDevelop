clouddevelop = clouddevelop || {};

(function() {
	clouddevelop.dialogBase = function(dialogName, options) {
		var $container = $("#" + dialogName + "-dialog");

		$container.dialog(options);

		function show() {
			$container.dialog("open");
		}

		function hide() {
			$container.dialog("close");
		}

		function showLoading() {
	    $("#" + dialogName + "-info").removeClass("error");
	    $("#" + dialogName + "-info").text("");
	    $("#" + dialogName + "-output").text("");
	    $("#" + dialogName + "-loading-container").show();
	    $("#" + dialogName + "-container").hide();
		}

		function reveal() {
	    $("#" + dialogName + "-loading-container").hide();
	    $("#" + dialogName + "-container").show();
		}

		function display(info, output, isError) {
			if (isError) {
        $("#" + dialogName + "-info").addClass("error");
			}
      $("#" + dialogName + "-info").text(data.info);
      $("#" + dialogName + "-output").text(data.output);
		}

		return {
			show: show,
			hide: hide,
			showLoading: showLoading,
			reveal: reveal,
			display: display
		};
	};
})();