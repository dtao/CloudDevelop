$(document).ready(function() {
  var codeEditor = clouddevelop.codeEditor($("#code-editor")),
      languageSelect = clouddevelop.languageSelect($("#language-select")),
      themeSelect = clouddevelop.themeSelect($("#theme-select")),
      consoleDialog = clouddevelop.consoleDialog($("#console-dialog")),
      // TODO: Refactor this foolishness (this is called a 'button' yet it contains a crapload of logic!)
      compileButton = clouddevelop.compileButton($("#compile-button"), codeEditor, languageSelect, consoleDialog),
      $contributorList = $('.contributor-list'),
      pusher = new Pusher($('#pusher-api-key').val()),
      infoFromPath = window.location.pathname.match(/\/([a-z0-9]+)\/(.*)/),
      collaborationId,
      contributor,
      pusherChannel,
      currentOwner,
      changeId = 0;

  function addContributor(contributor) {
    var $contributorItem = $('<li>').append($('<a href="javascript:void(0);" class="contributor-link">').text(contributor)),
        $instructionItem = $contributorList.find('.instruction');
    
    if ($instructionItem.length) {
      $contributorItem.insertBefore($instructionItem);
    } else {
      $contributorItem.appendTo($contributorList);
    }
  }
  
  function refreshContributorList(contributors) {
    $('<li>').addClass('left-most').text('Contributors:').appendTo($contributorList.empty());

    for (var i = 0; i < contributors.length; i++) {
      if (contributors[i] === currentOwner) {
        $('<li>').text(currentOwner + ' (editing)').appendTo($contributorList);
      } else {
        addContributor(contributors[i]);
      }
    }

    if (isOwner()) {
      $('<li>').addClass('instruction').text('(Click on a name to assign control.)').appendTo($contributorList);
    }
  }

  function isOwner() {
    return contributor == currentOwner;
  }

  function publishUpdate() {
    $.ajax('/update', {
      type: 'post',
      data: {
        change_id: changeId++,
        collaboration_id: collaborationId,
        contributor: contributor,
        content: codeEditor.getText()
      }
    });
  }

  function publishChangeControl(owner) {
    $.ajax('/change_control', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        owner: owner
      }
    });
  }

  function publishLanguageChange() {
    $.ajax('/change_language', {
      type: 'post',
      data: {
        collaboration_id: collaborationId,
        language: languageSelect.selectedLanguage()
      }
    });
  }
  
  collaborationId = infoFromPath[1];
  contributor = infoFromPath[2];
  pusherChannel = pusher.subscribe(collaborationId);
  currentOwner = $('#current-owner').val();

  if (contributor !== currentOwner) {
    codeEditor.setReadOnly(true);
  }
  
  languageSelect.onSelectedLanguageChanged(function(language, mode) {
    codeEditor.setMode(mode);
    if (isOwner()) {
      publishLanguageChange();
    }
  });

  themeSelect.onSelectedThemeChanged(function(theme) {
    codeEditor.setTheme(theme);
  });

  codeEditor.onChange(clouddevelop.throttle(publishUpdate, 500));

  $(document).delegate('.contributor-link', 'click', function() {
    var selectedContributor;

    // Only the current owner can assign a new owner.
    if (!isOwner()) {
      return;
    }

    selectedContributor = $(this).text();
    if (selectedContributor === contributor) {
      return;
    }

    codeEditor.setReadOnly(true);
    publishChangeControl(selectedContributor);
  });

  pusherChannel.bind('update', function(data) {
    if (data.contributor !== contributor) {
      codeEditor.applyChange(data);
    }
  });

  pusherChannel.bind('change_language', function(data) {
    if (!isOwner()) {
      languageSelect.selectLanguage(data.language);
    }
  });

  pusherChannel.bind('new_contributor', function(data) {
    addContributor(data.contributor);
  });

  pusherChannel.bind('change_control', function(data) {
    currentOwner = data.owner;

    if (isOwner()) {
      codeEditor.setReadOnly(false);
    }

    refreshContributorList(data.contributors);
  });

  languageSelect.selectLanguage($('#current-language').val());
});