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
      'end', 'ensure', 'false', 'for', 'if', 'in',
      'next', 'nil', 'redo', 'rescue', 'retry', 'return',
      'self', 'super', 'then', 'true', 'undef', 'unless',
      'until', 'when', 'while', 'yield', 'require', 'load',
      'raise', 'lambda', 'try', 'module', 'class']);
    var indentationWords = wordRegexp(['begin', 'class', 'def', 'do', 'if', 'unless', 'until', 'while', 'try']);
    var sketchupClasses = wordRegexp(['Animation','AppObserver','ArcCurve','Array','AttributeDictionaries',
      'AttributeDictionary','Behavior','BoundingBox','Camera','Color','Command','ComponentDefinition',
      'ComponentInstance','ConstructionLine','ConstructionPoint','Curve','DefinitionList','DefinitionObserver',
      'DefinitionsObserver','Drawingelement','Edge','EdgeUse','Entities','EntitiesObserver','Entity',
      'EntityObserver','Face','Geom','Group','Image','Importer','InputPoint','InstanceObserver',
      'LatLong','Layer','Layers','LayersObserver','Length','Loop','Material','Materials',
      'MaterialsObserver','Menu','Model','ModelObserver','Numeric','OptionsManager','OptionsProvider',
      'OptionsProviderObserver','Page','Pages','PagesObserver','PickHelper','Point3d','PolygonMesh',
      'RenderingOptions','RenderingOptionsObserver','SectionPlane','Selection','SelectionObserver',
      'Set','ShadowInfo','ShadowInfoObserver','Sketchup','SketchupExtension','String','Style','Styles',
      'Text','Texture','TextureWriter','Tool','Toolbar','Tools','ToolsObserver','Transformation','UI',
      'UTM','UVHelper','Vector3d','Vertex','View','ViewObserver','WebDialog']);

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
                    if (stream.peek().match(/\w/)) {
                        stream.skipToEnd();
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
                    if (stream.current().match(commonKeywords)) {
                        if (stream.current().match(indentationWords)) {
                            increaseIndent(state);
                        } else if (stream.current() === "end") {
                            decreaseIndent(state);
                        }
                        return "keyword";
                    } else if (stream.current().match(sketchupClasses)) {
                        return "meta";
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

            if (textAfter.match(/\}|end/)) {
              indentLevel -= 1;
            }

            return indentLevel * indentUnit;
        },
        electricChars: "}end"
    };
});

CodeMirror.defineMIME("text/x-ruby", "ruby");