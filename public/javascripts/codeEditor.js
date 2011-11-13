clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.codeEditor = function($textarea) {
    var changeHandler = $.noop,
        applyingChanges = false,
        lastChangeId = null,
        codeMirror = CodeMirror.fromTextArea($textarea.get(0), {
          lineNumbers: true,
          onChange: function(editor, change) {
            // I'm cheating a little bit here; according to the CodeMirror docs,
            // this function only gets passed the editor. HOWEVER, digging into
            // the source I see that it ALSO gets passed the data of what text
            // was changed. (Muhahaha!)
            if (!applyingChanges) {
              changeHandler(change);
            }
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

    function setReadOnly(readOnly) {
      codeMirror.setOption('readOnly', readOnly);
    }

    function applyChange(change) {
      if (change.changeId < lastChangeId) {
        return;
      }

      applyingChanges = true;
      codeMirror.setValue(change.content);
      lastChangeId = change.changeId;
      applyingChanges = false;
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
      setReadOnly: setReadOnly,
      applyChange: applyChange,
      loadCodeSnippet: loadCodeSnippet,
      setMode: setMode,
      setTheme: setTheme
    };
  };
}());