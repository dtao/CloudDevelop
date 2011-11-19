$(document).ready(function() {
  var collaborationId = $('#collaboration-id').val(),
      contributor = $('#contributor').val(),
      codeEditor = clouddevelop.codeEditor($('#code-editor'), collaborationId),
      languageSelect = clouddevelop.languageSelect($('#language-select')),
      themeSelect = clouddevelop.themeSelect($('#theme-select')),
      consoleDialog = clouddevelop.consoleDialog($('#console-dialog')),
      // TODO: Refactor this foolishness (this is called a 'button' yet it contains a crapload of logic!)
      compileButton = clouddevelop.compileButton($('#compile-button'), codeEditor, languageSelect, consoleDialog),
      $gistButton = $('#gist-button').button(),
      $gistDialog = $('#gist-dialog').dialog({
        autoOpen: false,
        buttons: {
          OK: function() {
            $.ajax('/gist', {
              type: 'post',
              data: {
                user: $('#github-user'),
                password: $('#github-password'),
                name: $('#gist-name').val(),
                description: $('#gist-description').val(),
                content: codeEditor.getContent()
              },
              success: function(data) {
                clouddevelop.notify(data);
              },
              error: function(jqXHR, statusText, errorText) {
                clouddevelop.notify(errorText || statusText);
              }
            });
          }
        }
      }),
      $contributorList = $('.contributor-list'),
      pusher = new Pusher($('#pusher-api-key').val()),
      pusherChannel = pusher.subscribe(collaborationId),
      updatingLanguageFromNotification = false;

  function addContributor(contributor, cssClass) {
    var $listItem = $('<li>').text(contributor);
    if (cssClass) {
      $listItem.addClass(cssClass);
    }
    $listItem.appendTo($contributorList);
  }
  
  function refreshContributorList(contributors) {
    $('<li>').addClass('left-most').text('Contributors:').appendTo($contributorList.empty());

    for (var i = 0; i < contributors.length; i++) {
      if (contributors[i] === contributor) {
        addContributor(contributor, 'current');
      } else {
        addContributor(contributors[i]);
      }
    }
  }

  function isCollaborating() {
    // Check that there is at least one contributor besides the current user
    // (and ignore the starting label item).
    return $contributorList.find('li').length > 2;
  }

  function handleChange(type, data) {
    switch (type) {
      case 'selection':
        // Don't raise selection change updates if there's only one person
        // looking at the document.
        if (!isCollaborating()) {
          return;
        }

        publishSelectionChange(data);
        break;
    }
  }

  function publishSelectionChange(range) {
    $.ajax('/select', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        contributor: contributor,
        range: range
      }
    });
  }

  function publishLanguageChange() {
    $.ajax('/change_language', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        contributor: contributor,
        language: languageSelect.selectedLanguage()
      }
    });
  }
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);

    if (updatingLanguageFromNotification) {
      updatingLanguageFromNotification = false;
      return;
    }
    
    publishLanguageChange();
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  codeEditor.onChange(clouddevelop.throttle(handleChange, 500));

  $gistButton.click(function() {
    $gistDialog.dialog('open');
  });

  pusherChannel.bind('select', function(data) {
    if (data.contributor !== contributor) {
      codeEditor.highlightRange(data.range);
    }
  });

  pusherChannel.bind('change_language', function(data) {
    if (data.contributor !== contributor && data.language !== languageSelect.selectedLanguage()) {
      updatingLanguageFromNotification = true;
      languageSelect.selectLanguage(data.language);
      clouddevelop.notify(data.contributor + ' changed the language to <span class="notification-highlight">' + data.language + '</span>.');
    }
  });

  pusherChannel.bind('new_contributor', function(data) {
    addContributor(data.contributor);
    clouddevelop.notify('<span class="notification-highlight">' + data.contributor + '</span> joined.');
  });

  languageSelect.selectLanguage($('#current-language').val(), true);
});