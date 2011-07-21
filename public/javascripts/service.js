clouddevelop = clouddevelop || {};

clouddevelop.service = (function() {
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

	function open(id) {
		var promise = createPromise();

		$.ajax("/code_snippets/" + id + ".js", {
			dataType: 'json',
			type: 'get',
			success: function(data, textStatus, jqXHR) {
				promise.success(data);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				promise.error(errorThrown || textStatus);
			}
		});

		return promise;
	}

	function compile(code, language) {
		var promise = createPromise();

		$.ajax("/compile.js", {
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
				promise.error(errorThrown || textStatus);
			}
		});

		return promise;
	}

	function save(code, language) {
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
				promise.error(errorThrown || textStatus);
			}
		});

		return promise;
	}

	function update(id, code) {
		var promise = createPromise();

		$.ajax("/code_snippets/" + id + ".js", {
			data: {
				id: id,
				code_snippet: code
			},
			dataType: 'json',
			type: 'put',
			success: function(data, textStatus, jqXHR) {
				promise.success(data);
			},
			error: function(jqXHR, textStatus, errorThrown) {
				promise.error(errorThrown || textStatus);
			}
		});

		return promise;
	}

	return {
		open: open,
		compile: compile,
		save: save,
		update: update
	};
}());