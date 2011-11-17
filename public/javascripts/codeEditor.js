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
          tabMode: 'shift',
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

    function clearHighlight() {
      if (highlight) {
        highlight.clear();
        highlight = null;
      }
    }

    function getContent() {
      return codeMirror.getValue();
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
      codeMirror.setOption('mode', mode);
    }

    function setTheme(theme) {
      codeMirror.setOption('theme', theme);
    }

    codeMirror.id = 'code-mirror-editor';
    mobwrite.share(codeMirror);

    return {
      onChange: onChange,
      getContent: getContent,
      highlightRange: highlightRange,
      setMode: setMode,
      setTheme: setTheme
    };
  };
}());