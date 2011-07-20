clouddevelop = clouddevelop || {};

(function() {
  var modeMap = {
    c: "text/x-csrc",
    cpp: "text/x-c++src",
    cs: "text/x-csharp",
    haskell: "text/x-haskell",
    java: "text/x-java",
    javascript: "text/javascript",
    lua: "text/x-lua",
    perl: "text/x-perl",
    php: "text/x-php",
    python: "text/x-python",
    ruby: "text/x-ruby",
    scheme: "text/x-scheme",
    smalltalk: "text/x-stsrc"
  };

  clouddevelop.languageSelect = function($select, codeEditor) {
  	var $combobox = $select.combobox();
    $select.bind("comboboxupdate", function() {
      var selectedLanguage = $combobox.val();
      codeEditor.setMode(modeMap[selectedLanguage]);
    });

    function selectedLanguage() {
    	return $combobox.val();
    }

    function selectLanguage(language) {
	    $combobox.val(language);
	    $combobox.combobox("refresh");
    }

    return {
    	selectedLanguage: selectedLanguage,
    	selectLanguage: selectLanguage
    };
  };
})();