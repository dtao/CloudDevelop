function displaySnippetInfo(id, codeSnippet) {
  var $fileInfoBox = $("#file-info-box").empty();
  if (codeSnippet) {
    $fileInfoBox.append($('<p>').html('Snippet Id: <a href="/' + id + '">' + id + '</a>, version #' + codeSnippet.version));
  }
}

var selectLanguage = function(language) {
  // Do nothing (this is a placeholder).
}

$(document).ready(function() {
  var codeEditor = clouddevelop.codeEditor($("#code-editor")),
    languageSelect = clouddevelop.languageSelect($("#language-select")),
    themeSelect = clouddevelop.themeSelect($("#theme-select")),
    consoleDialog = clouddevelop.consoleDialog($("#console-dialog")),
    compileButton = clouddevelop.compileButton($("#compile-button"), codeEditor, languageSelect, consoleDialog),
    openDialog = clouddevelop.openDialog($("#open-dialog")),
    saveDialog = clouddevelop.saveDialog($("#save-dialog")),
    currentSnippetId = null;
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  openDialog.onSnippetLoaded(function(id, codeSnippet) {
    currentSnippetId = id;
    codeEditor.loadCodeSnippet(codeSnippet);
    if (codeSnippet.language) {
      languageSelect.selectLanguage(codeSnippet.language);
    }
    displaySnippetInfo(id, codeSnippet);
  });

  saveDialog.onSnippetSaved(function(id, codeSnippet) {
    currentSnippetId = id;
    displaySnippetInfo(id, codeSnippet);
  });

  $("#new-menu-item").click(function() {
    currentSnippetId = null;
    displaySnippetInfo(null);
    codeEditor.clear();
  });

  $("#open-menu-item").click(function() {
    openDialog.clear();
    openDialog.shrink();
    openDialog.reveal();
    openDialog.show();
  });

  $("#save-menu-item").click(function() {
    var code = codeEditor.getValue(),
      language = languageSelect.selectedLanguage();
    
    if (code === "") {
      return;
    }
    
    if (currentSnippetId) {
      saveDialog.update(currentSnippetId, code);
    } else {
      saveDialog.save(code, language);
    }
  });

  // Big-time hack!
  selectLanguage = function(language) {
    languageSelect.selectLanguage(language);
  };
});