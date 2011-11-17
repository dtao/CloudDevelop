clouddevelop = clouddevelop || {};

(function() {
  var modeMap = {
    c: "text/x-csrc",
    clojure: "text/x-clojure",
    cpp: "text/x-c++src",
    cs: "text/x-csharp",
    haskell: "text/x-haskell",
    groovy: "text/x-groovy",
    java: "text/x-java",
    javascript: "text/javascript",
    lua: "text/x-lua",
    perl: "text/x-perl",
    php: "text/x-php",
    python: "text/x-python",
    ruby: "text/x-ruby",
    scheme: "text/x-scheme",
    smalltalk: "text/x-stsrc",
    vb: "text/x-vb"
  };

  clouddevelop.languageSelect = function($select) {
  	var $combobox = $select.combobox(),
      selectedLanguageChangedHandler = $.noop;
    
    $select.bind("comboboxupdate", function() {
      var selectedLanguage = $combobox.val(),
        mode = modeMap[selectedLanguage];
      
      selectedLanguageChangedHandler(selectedLanguage, mode);
    });

    function selectedLanguage() {
    	return $combobox.val();
    }

    function selectLanguage(language) {
      if (language !== $combobox.val()) {
        $combobox.val(language);
        $combobox.combobox("refresh");
      }
    }

    function onSelectedLanguageChanged(handler) {
      selectedLanguageChangedHandler = handler;
    }

    return {
    	selectedLanguage: selectedLanguage,
    	selectLanguage: selectLanguage,
      onSelectedLanguageChanged: onSelectedLanguageChanged
    };
  };
})();