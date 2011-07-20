clouddevelop = clouddevelop || {};

(function() {
	clouddevelop.themeSelect = function($select, codeEditor) {
		var $combobox = $select.combobox();
	  $combobox.bind("comboboxupdate", function() {
	    var selectedTheme = $combobox.val();
	    codeEditor.setTheme(selectedTheme);
	  });
	};
})();