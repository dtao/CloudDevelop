CodeMirror.defineMode("ruby", function(config) {
  var indentUnit = config.indentUnit;

  function wordRegexp(words) {
    return new RegExp("^(?:" + words.join("|") + ")$");
  }

  function increaseIndent(state) {
    state.indentLevel += 1;
  }

  function decreaseIndent(state) {
    if (state.indentLevel > 0) {
      state.indentLevel -= 1;
    }
  }

  var identifierStarters = /[_A-Za-z]/;
  var wordOperators = wordRegexp(['and', 'or', 'not', '&&', '||']);
  var commonKeywords = wordRegexp(['alias', 'BEGIN', 'begin', 'break', 'case',
    'def', 'defined', 'do', 'else', 'elsif', 'END',
    'end', 'ensure', 'for', 'if', 'in', 'lambda', 'load',
    'next', 'raise', 'redo', 'rescue', 'retry', 'return',
    'self', 'super', 'then', 'try', 'undef', 'unless',
    'until', 'when', 'while', 'yield']);
  var specialConstants = wordRegexp(['true', 'false', 'nil']);
  var metaKeywords = wordRegexp(['require', 'class', 'module', 'private']);
  var indentationWords = wordRegexp(['begin', 'class', 'def', 'do', 'if', 'module', 'unless', 'until', 'while', 'try']);

  return {
    startState: function() {
      return {
        context: 'normal',
        stringMarker: /"/,
        stringMarkerInverse: /[^"]/,
        indentLevel: 0
      };
    },
    token: function(stream, state) {
      var ch = stream.next();

      if (state.context == 'normal') {
        if (ch == "{") {
          increaseIndent(state);
        }

        if (ch == "}") {
          decreaseIndent(state);
        }

        if (ch == "#") { /* Detect comments. */
          stream.skipToEnd();
          return "comment";

        } else if (ch == "@") { /* Detect decorators. */
          if (stream.peek().match(/[@\w]/)) {
            stream.eatWhile(/\w/);
            return "tag";
          }

        } else if (ch == ".") { /* Detect object methods. */
          stream.next();
          if (stream.peek().match(/\w/)) {
            stream.eatWhile(/[A-Za-z0-9_]/);
            return "def";
          }

        } else if ((ch == "'") || (ch == '"')) { /* Detect strings. */
          if (ch == "'") {
            state.stringMarker = /'/;
            state.stringMarkerInverse = /[^']/;
          } else {
            state.stringMarker = /"/;
            state.stringMarkerInverse = /[^"]/;
          }
          stream.eatWhile(state.stringMarker);
          if (stream.current().length >= 3) {
            state.context = 'string';
          }
          stream.eatWhile(state.stringMarkerInverse)
          stream.next();
          return "string";
        
        } else if (ch == ":") {
          stream.eatWhile(/[^\s]/);
          return "attribute";

        } else if (ch.match(/[\d.]/)) { /* Detect numbers. */
          stream.eatWhile(/[\d\.abcdefox]/);
          return "number";
        
        } else if (ch.match(/\w/)) { /* Detect keywords and SU classes. */
          stream.eatWhile(/\w/);
          if (stream.current().match(indentationWords)) {
            increaseIndent(state);
          } else if (stream.current() === "end") {
            decreaseIndent(state);
          }

          if (stream.current().match(commonKeywords)) {
            return "keyword";

          } else if (stream.current().match(specialConstants)) {
            return "atom";
            
          } else if (stream.current().match(metaKeywords)) {
            return "def";
          }
        }
      } else { /* We are in a multi-line string */
        stream.eatWhile(state.stringMarkerInverse); /* Eat the rest of the string. */
        numQuoted = stream.current().length;
        stream.eatWhile(state.stringMarker); /* Eat the closing quotes if they exist. */
        if (stream.current().length - numQuoted >= 3) {
          state.context = 'normal';
        }
        return "string";
      }
    },
    indent: function(state, textAfter) {
      var indentLevel = state.indentLevel;

      if (textAfter.match(/^\s*\}|end$/)) {
        indentLevel -= 1;
      }

      return indentLevel * indentUnit;
    },
    electricChars: "}end"
  };
});

CodeMirror.defineMIME("text/x-ruby", "ruby");