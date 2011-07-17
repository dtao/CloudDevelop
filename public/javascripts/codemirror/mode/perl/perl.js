(function() {
  function keywords(str) {
    var obj = {}, words = str.split(" ");
    for (var i = 0; i < words.length; ++i) obj[words[i]] = true;
    return obj;
  }
  var perlKeywords =
    keywords("not exp log srand xor s qq qx x length uc ord and print chr for qw q join use sub tied eval int lc m cos y abs ne open hex ref scalar sqrt printf each return local or undef oct time foreach alarm chdir kill exec gt sin sort split close");
  function heredoc(delim) {
    return function(stream, state) {
      if (stream.match(delim)) state.tokenize = null;
      else stream.skipToEnd();
      return "string";
    }
  }
  var perlConfig = {
    name: "clike",
    keywords: perlKeywords,
    atoms: keywords("true false null"),
    multiLineStrings: true,
    hooks: {
      "#": function(stream, state) {
        stream.skipToEnd();
        return "comment";
      },      
      "$": function(stream, state) {
        stream.eatWhile(/[\w\$_]/);
        return "variable-2";
      },
      "@": function(stream, state) {
          stream.eatWhile(/[\w\$_]/);
          return "variable-2";
      },
      "%": function(stream, state) {
          stream.eatWhile(/[\w\$_]/);
          return "variable-2";
      },
      "&": function(stream, state) {
          stream.eatWhile(/[\w\$_]/);
          return "variable-2";
      },
      "<": function(stream, state) {
        if (stream.match(/<</)) {
          stream.eatWhile(/[\w\.]/);
          state.tokenize = heredoc(stream.current().slice(3));
          return state.tokenize(stream, state);
        }
        return false;
      },
    }
  };

  CodeMirror.defineMIME("text/x-perl", perlConfig);
})();