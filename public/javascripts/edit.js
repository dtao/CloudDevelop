function displaySnippetInfo(id, version) {
  var $fileInfoBox = $("#file-info-box").empty();
  if (version) {
    $fileInfoBox.append($('<p>').html('Snippet Id: <a href="/' + id + '">' + id + '</a>, version #' + version));
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
      // TODO: Refactor this foolishness (this is called a 'button' yet it contains a crapload of logic!)
      compileButton = clouddevelop.compileButton($("#compile-button"), codeEditor, languageSelect, consoleDialog),
      $window = $(window),
      $header = $('#header'),
      $navigation = $('#navigation'),
      $toolbar = $('#toolbar-area'),
      $codeMirror = $('.CodeMirror-scroll'),
      $button = $('#button-area'),
      $footer = $('.footer'),
      currentSnippetId = null,
      pusher = new Pusher($('#pusher-api-key').val()),
      infoFromPath = window.location.pathname.match(/\/(\d+)\/(.*)/),
      collaborationId,
      contributor,
      channel;
  
  collaborationId = infoFromPath[1];
  contributor = infoFromPath[2];
  channel = pusher.subscribe(collaborationId);
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  channel.bind('update', function(data) {
    if (data.contributor !== contributor) {
      codeEditor.applyChange(data.change);
    }
  });

  channel.bind('new_contributor', function(data) {
    $('<li>').text(data.contributor).appendTo($('.collaborators-list'));
  });

  codeEditor.onChange(function(change) {
    $.ajax('/collaborate', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        contributor: contributor,
        change: {
          from: change.from,
          to: change.to,
          text: change.text.join("\n")
        }
      }
    });
  });

  // Big-time hack!
  selectLanguage = function(language) {
    languageSelect.selectLanguage(language);
  };
});