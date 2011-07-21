clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.codeEditor = function($textarea) {
    var codeMirror = CodeMirror.fromTextArea($textarea.get(0), {
      lineNumbers: true,
      onChange: function() {
        var fileInfoBox = $("#file-info-box > p");
        if (fileInfoBox) {
          var text = fileInfoBox.text();
          if (text.indexOf("*", text.length - 1) === -1) {
            fileInfoBox.text(text + "*");
          }
        }
      }
    });

    function getValue() {
      return codeMirror.getValue();
    }

    function loadCodeSnippet(codeSnippet) {
      if (!codeSnippet) {
        codeMirror.setValue("");
        return;
      }

      codeMirror.setValue(codeSnippet.snippet);
    }

    function setMode(mode) {
      codeMirror.setOption("mode", mode);
    }

    function setTheme(theme) {
      codeMirror.setOption("theme", theme);
    }

    return {
      getValue: getValue,
      loadCodeSnippet: loadCodeSnippet,
      setMode: setMode,
      setTheme: setTheme
    };
  };
})();