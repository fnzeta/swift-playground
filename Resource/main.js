(function() {
	var editor = ace.edit("code");
	editor.setTheme("ace/theme/tomorrow_night_eighties");
	editor.session.setMode("ace/mode/swift");
	editor.focus();

	var localStorage = window.localStorage || { setItem: function() { }, getItem: function() { return "" } };
	
	var savedCode = localStorage.getItem("code") || "";
	editor.setValue(savedCode, 1);

	$("#code").on("keypress", function(e) {
		var meta = e.metaKey || e.ctrlKey;
		var enterKey = (e.keyCode || e.which);
		var enter = enterKey === 10 || enterKey === 13;
		if (meta && enter && editor.getValue()) {
			$("#output").html("");
			$("#output").append("<p class='ide'>Executing...</p>");
			$.ajax({
				url: 'https://playground-swift-playground.7e14.starter-us-west-2.openshiftapps.com/run',
				method: 'POST',
				data: editor.getValue(),
				success: function(data) {
					var output = data.replace(/\n/g, '<br/>');
					var className = 'msg';
					if (output.match(/main\.swift:/i) != null) {
						className = 'msg-err';
					}
					$("#output").html('<p class="' + className + '">' + output + '</p>');			
					localStorage.setItem("code", editor.getValue());
				}
			});
		}
	});

})();
