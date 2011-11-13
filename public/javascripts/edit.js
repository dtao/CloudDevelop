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
      channelId = window.location.pathname.match(/\/(\d+)/)[1]
      channel = pusher.subscribe(channelId);
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  channel.bind('update', function(data) {
    codeEditor.setText(data.text);
  });

  codeEditor.onChange(function() {
    $.ajax('/collaborate', {
      type: 'post',
      data: {
        channel_id: channelId,
        text: codeEditor.getText()
      }
    });
  });

  // Big-time hack!
  selectLanguage = function(language) {
    languageSelect.selectLanguage(language);
  };
});