clouddevelop = clouddevelop || {};

(function() {
	clouddevelop.themeSelect = function($select) {
		var $combobox = $select.combobox(),
			selectedThemeChangedHandler = $.noop;
		
	  $combobox.bind("comboboxupdate", function() {
	    var selectedTheme = $combobox.val();
	    selectedThemeChangedHandler(selectedTheme);
	  });

	  function onSelectedThemeChanged(handler) {
	  	selectedThemeChangedHandler = handler;
	  }

	  return {
	  	onSelectedThemeChanged: onSelectedThemeChanged
	  };
	};
})();