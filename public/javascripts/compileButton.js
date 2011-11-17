clouddevelop = clouddevelop || {};

(function() {
	clouddevelop.compileButton = function($input, codeEditor, languageSelect, consoleDialog) {
		$button = $input.button();
    
    $button.click(function() {
      var code = codeEditor.getContent(),
        language = languageSelect.selectedLanguage();

      consoleDialog.showLoading();
      consoleDialog.show();

      clouddevelop.service.compile(code, language)
        .onSuccess(function(data) {
        	consoleDialog.reveal();
        	consoleDialog.display(data.info, data.output, data.isError);
        })
        .onError(function(data) {
          consoleDialog.reveal();
          consoleDialog.display("", JSON.stringify(data), true);
        });
    });
	};
})();