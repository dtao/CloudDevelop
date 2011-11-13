clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.codeEditor = function($textarea) {
    var changeHandler = $.noop,
        codeMirror = CodeMirror.fromTextArea($textarea.get(0), {
          lineNumbers: true,
          onChange: function() {
            changeHandler();
          }
        });
    
    function onChange(handler) {
      changeHandler = handler;
    }

    function clear() {
      codeMirror.setValue("");
    }

    function getText() {
      return codeMirror.getValue();
    }

    function setText(text) {
      codeMirror.setValue(text);
    }

    function loadCodeSnippet(codeSnippet) {
      if (!codeSnippet) {
        codeMirror.setValue("");
        return;
      }

      codeMirror.setValue(codeSnippet.latest);
    }

    function setMode(mode) {
      codeMirror.setOption("mode", mode);
    }

    function setTheme(theme) {
      codeMirror.setOption("theme", theme);
    }

    return {
      onChange: onChange,
      clear: clear,
      getText: getText,
      setText: setText,
      loadCodeSnippet: loadCodeSnippet,
      setMode: setMode,
      setTheme: setTheme
    };
  };
}());