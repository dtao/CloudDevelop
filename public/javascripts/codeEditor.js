clouddevelop = clouddevelop || {};

(function() {
  clouddevelop.codeEditor = function($textarea) {
    var changeHandler = $.noop,
        applyingChanges = false,
        lastChangeId = null,
        selection,
        highlight,
        codeMirror = CodeMirror.fromTextArea($textarea.get(0), {
          lineNumbers: true,
          onChange: function() {
            // I'm cheating a little bit here; according to the CodeMirror docs,
            // this function only gets passed the editor. HOWEVER, digging into
            // the source I see that it ALSO gets passed the data of what text
            // was changed. (Muhahaha!)
            if (!applyingChanges) {
              changeHandler('content');
            }
          },
          onCursorActivity: function() {
            codeMirror.setLineClass(currentLine, null);
            currentLine = codeMirror.setLineClass(codeMirror.getCursor().line, 'active-line');

            if (codeMirror.somethingSelected()) {
              selection = {
                from: codeMirror.getCursor(true),
                to: codeMirror.getCursor(false)
              };
              changeHandler('selection', selection);
            } else if (selection) {
              selection = null;
              changeHandler('selection', selection);
            }
          }
        }),
        currentLine = codeMirror.setLineClass(0, 'active-line');
    
    function onChange(handler) {
      changeHandler = handler;
    }

    function clear() {
      codeMirror.setValue("");
    }

    function clearHighlight() {
      if (highlight) {
        highlight.clear();
        highlight = null;
      }
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

    function isPosition(position) {
      return typeof position === 'object' && ('line' in position) && ('ch' in position);
    }

    function isRange(range) {
      return typeof range === 'object' && isPosition(range.from) && isPosition(range.to);
    }

    function makePositionNumeric(position) {
      position.line = +position.line;
      position.ch = +position.ch;
    }

    function makeRangeNumeric(range) {
      makePositionNumeric(range.from);
      makePositionNumeric(range.to);
    }

    function highlightRange(range) {
      clearHighlight();

      if (!isRange(range)) {
        return;
      }

      makeRangeNumeric(range);
      highlight = codeMirror.markText(range.from, range.to, 'marked-text');
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
      highlightRange: highlightRange,
      setMode: setMode,
      setTheme: setTheme
    };
  };
}());