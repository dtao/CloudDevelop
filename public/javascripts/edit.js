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
      $contributorList = $('.contributor-list'),
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
      currentOwner,
      changeId = 0;
  
  function refreshContributorList(contributors) {
    $('<li>').text('Contributors:').appendTo($contributorList.empty());

    for (var i = 0; i < contributors.length; i++) {
      if (contributors[i] === currentOwner) {
        $('<li>').text(currentOwner + ' (editing)').appendTo($contributorList);
      } else {
        $('<li>').append($('<a class="contributor-link">').text(contributors[i])).appendTo($contributorList);
      }
    }
  }
  
  collaborationId = infoFromPath[1];
  contributor = infoFromPath[2];
  channel = pusher.subscribe(collaborationId);
  currentOwner = $('#current-owner').val();

  if (contributor !== currentOwner) {
    codeEditor.setReadOnly(true);
  }
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
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
    var selectedContributor;

    // Only the current owner can assign a new owner.
    if (contributor !== currentOwner) {
      return;
    }

    selectedContributor = $(this).text();
    if (selectedContributor === contributor) {
      return;
    }

    codeEditor.setReadOnly(true);
    $.ajax('/change_control', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        owner: selectedContributor
      }
    });
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
    currentOwner = data.owner;

    if (contributor === currentOwner) {
      codeEditor.setReadOnly(false);
    }

    refreshContributorList(data.contributors);
  });
});