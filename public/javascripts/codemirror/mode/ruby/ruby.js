CodeMirror.defineMode("ruby", function(config) {
	var indentUnit = config.indentUnit,
		keywords = {
			"alias": true,
			"and": true,
			"begin": true,
			"break": true,
			"case": true,
			"class": true,
			"def": true,
			"defined?": true,
			"do": true,
			"else": true,
			"elsif": true,
			"end": true,
			"ensure": true,
			"false": true,
			"for": true,
			"if": true,
			"in": true,
			"module": true,
			"next": true,
			"nil": true,
			"not": true,
			"or": true,
			"redo": true,
			"rescue": true,
			"retry": true,
			"return": true,
			"self": true,
			"super": true,
			"then": true,
			"true": true,
			"undef": true,
			"unless": true,
			"until": true,
			"when": true,
			"while": true,
			"yield": true
		};

	function startState() {
		var indentLevel = 0;
		
		return {
			indentLevel: indentLevel
		};
	}

	function token(stream, state) {
  	if (stream.eatSpace()) {
  		return null;
  	}

  	if (stream.sol()) {
  		if (stream.peek() == "#") {
  			stream.skipToEnd();
  			return "comment";
  		} else if (stream.match("def", true)) {
				increaseIndent(state);
  		}
  	}

  	if (stream.match("do", true)) {
  		increaseIndent(stream);
  	}

  	if (stream.match("end", true)) {
  		decreaseIndent(state);
  	}

  	if (stream.eat('"')) {
  		stream.skipTo('"');
  		return "string";
  	}

  	if (stream.eat("{")) {
  		increaseIndent(state);
  	}

  	if (stream.eat("}")) {
  		decreaseIndent(state);
  	}

  	if (stream.eatWhile(/[^\s{}]/)) {
  		var word = stream.current();

  		if (startsWith(word, ":")) {
  			return "attribute";
  		} else if (keywords[word]) {
  			return "keyword";
  		}
  	}

  	return null;
	}

	function indent(state, textAfter) {
		return state.indentLevel * indentUnit;
	}

	function increaseIndent(state) {
		state.indentLevel += 1;
	}

	function decreaseIndent(state) {
		if (state.indentLevel > 0) {
			state.indentLevel -= 1;
		}
	}

	function startsWith(string, substr) {
		return string.lastIndexOf(substr, 0) === 0;
	}

  return {
    startState: startState,
    token: token,
    indent: indent
  };
});

CodeMirror.defineMIME("text/x-ruby", "ruby");
