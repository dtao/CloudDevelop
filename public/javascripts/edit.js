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
      infoFromPath = window.location.pathname.match(/\/([a-z0-9]+)\/(.*)/),
      collaborationId,
      contributor,
      channel,
      changeId = 0;
  
  collaborationId = infoFromPath[1];
  contributor = infoFromPath[2];
  channel = pusher.subscribe(collaborationId);

  if (contributor !== $('#current-owner').val()) {
    codeEditor.setReadOnly(true);
  }
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  channel.bind('update', function(data) {
    if (data.contributor !== contributor) {
      codeEditor.applyChange(data);
    }
  });

  channel.bind('new_contributor', function(data) {
    $('<li>').text(data.contributor).appendTo($('.collaborators-list'));
  });

  channel.bind('change_control', function(data) {
    if (data.contributor === contributor) {
      codeEditor.setReadOnly(false);
      alert("You have been given control.");
    }
  });

  codeEditor.onChange(function() {
    $.ajax('/update', {
      type: 'post',
      data: {
        change_id: changeId++,
        collaboration_id: collaborationId,
        contributor: contributor,
        content: codeEditor.getText()
      }
    });
  });

  $(document).delegate('.contributor-link', 'click', function() {
    var selectedContributor = $(this).text();

    if (selectedContributor === contributor) {
      return;
    }

    codeEditor.setReadOnly(true);
    $.ajax('/change_control', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        contributor: selectedContributor
      },
      complete: function() {
        alert("Gave control to " + selectedContributor + ".");
      }
    });
  });

  // Big-time hack!
  selectLanguage = function(language) {
    languageSelect.selectLanguage(language);
  };
});