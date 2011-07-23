CodeMirror.defineMode("vb", function(config) {
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
  var wordOperators = wordRegexp(['And', 'Or', 'AndAlso', 'OrElse', 'Xor']);
  var commonKeywords = wordRegexp(['AddHandler', 'AddressOf', 'Alias', 'And',
    'AndAlso', 'Ansi', 'As', 'Assembly',
    'Auto', 'Boolean', 'ByRef', 'Byte',
    'ByVal', 'Call', 'Case', 'Catch',
    'CBool', 'CByte', 'CChar', 'CDate',
    'CDec', 'CDbl', 'Char', 'CInt',
    'Class', 'CLng', 'CObj', 'Const',
    'CShort', 'CSng', 'CStr', 'CType',
    'Date', 'Decimal', 'Declare', 'Default',
    'Delegate', 'Dim', 'DirectCast', 'Do',
    'Double', 'Each', 'Else', 'ElseIf',
    'End', 'Enum', 'Erase', 'Error',
    'Event', 'Exit', 'False', 'Finally',
    'For', 'Friend', 'Function', 'Get',
    'GetType', 'GoSub', 'GoTo', 'Handles',
    'If', 'Implements', 'Imports', 'In',
    'Inherits', 'Integer', 'Interface', 'Is',
    'Let', 'Lib', 'Like', 'Long',
    'Loop', 'Me', 'Mod', 'Module',
    'MustInherit', 'MustOverride', 'MyBase', 'MyClass',
    'Namespace', 'New', 'Next', 'Not',
    'Nothing', 'NotInheritable', 'NotOverridable', 'Object',
    'On', 'Option', 'Optional', 'Or',
    'OrElse', 'Overloads', 'Overridable', 'Overrides',
    'ParamArray', 'Preserve', 'Private', 'Property',
    'Protected', 'Public', 'RaiseEvent', 'ReadOnly',
    'ReDim', 'REM', 'RemoveHandler', 'Resume',
    'Return', 'Select', 'Set', 'Shadows',
    'Shared', 'Short', 'Single', 'Static',
    'Step', 'Stop', 'String', 'Structure',
    'Sub', 'SyncLock', 'Then', 'Throw',
    'To', 'True', 'Try', 'TypeOf',
    'Unicode', 'Until', 'Variant', 'Wend', 'When',
    'While', 'With', 'WithEvents', 'WriteOnly', 'Xor']);
  var specialConstants = wordRegexp(['True', 'False', 'Nothing']);
  var metaKeywords = wordRegexp(['Imports', 'Class', 'Module', 'Structure', 'Interface', 'Delegate', 'Function', 'Sub']);
  var indentationWords = wordRegexp(['Class', 'Module', 'Structure', 'Interface', 'Function', 'Sub', 'If', 'For', 'While', 'Do', 'Using', 'Try']);

  return {
    startState: function() {
      return {
        context: 'normal',
        stringMarker: /"/,
        stringMarkerInverse: /[^"]/,
        indentLevel: 0,
        endingBlock: false
      };
    },
    token: function(stream, state) {
      var ch = stream.next();

      if (state.context == 'normal') {
        if (ch == "'") { /* Detect comments. */
          stream.skipToEnd();
          return "comment";

        } else if (ch == ".") { /* Detect object methods. */
          stream.next();
          if (stream.peek().match(/\w/)) {
            stream.eatWhile(/[A-Za-z0-9_]/);
            return "def";
          }

        } else if (ch == '"') { /* Detect strings. */
          state.stringMarker = /"/;
          state.stringMarkerInverse = /[^"]/;

          stream.eatWhile(state.stringMarker);
          if (stream.current().length >= 3) {
            state.context = 'string';
          }
          stream.eatWhile(state.stringMarkerInverse)
          stream.next();
          return "string";
        
        } else if (ch == "[") {
          stream.eatWhile(/[^\]]/);
          return "attribute";

        } else if (ch.match(/[\d.]/)) { /* Detect numbers. */
          stream.eatWhile(/[\d\.abcdefox]/);
          return "number";
        
        } else if (ch.match(/\w/)) { /* Detect keywords and SU classes. */
          stream.eatWhile(/\w/);
          if (stream.current() === 'End') {
            state.endingBlock = true;
            decreaseIndent(state);
          } else if (stream.current().match(indentationWords)) {
            if (state.endingBlock) {
              state.endingBlock = false;
            } else {
              increaseIndent(state);
            }
          }

          if (stream.current().match(commonKeywords)) {
            return "keyword";

          } else if (stream.current().match(specialConstants)) {
            return "atom";
            
          } else if (stream.current().match(metaKeywords)) {
            return "keyword";
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

      if (textAfter.match(/^\s*(End|Wend|Else|ElseIf\s|Case\s|Catch|Finally)/)) {
        indentLevel -= 1;
      }

      return indentLevel * indentUnit;
    },
    electricChars: "dehy "
  };
});

CodeMirror.defineMIME("text/x-vb", "vb");