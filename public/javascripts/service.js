ideoneService = (function() {
	function createPromise() {
		var successHandler = function() {},
			errorHandler = function() {};
		
		function onSuccess(handler) {
			successHandler = handler;
			return this;
		}

		function onError(handler) {
			errorHandler = handler;
			return this;
		}

		function success(data) {
			successHandler(data);
		}

		function error(data) {
			errorHandler(data);
		}
		
		return {
			onSuccess: onSuccess,
			onError: onError,
			success: success,
			error: error
		};
	}

	function execute(code, language) {
		var promise = createPromise();

		$.ajax("/code_snippets.js", {
			data: {
				code_snippet: code,
				language: language
			},
			dataType: 'json',
			type: 'post',
			success: function(data, textStatus, jqXHR) {
				promise.success(data);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				promise.error(textStatus);
			}
		});

		return promise;
	}

	return {
		execute: execute
	};
}());