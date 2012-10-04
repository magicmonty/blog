$(function() {	
	$('*[rel="popover"]').popover();
	$('*[rel="tooltip"]').tooltip();
	$("#error").html('The requested url "' + window.location + '" was not found on this server!')
});
