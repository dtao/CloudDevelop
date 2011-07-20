clouddevelop = clouddevelop || {};

(function() {
	clouddevelop.themeSelect = function($select, editor) {
		var $combobox = $select.combobox();
	  $combobox.bind("comboboxupdate", function() {
	    var selectedTheme = $combobox.val();
	    editor.setOption("theme", selectedTheme);
	  });
	};
})();