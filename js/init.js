$(function() {	
	$('*[rel="popover"]').popover();
	$('*[rel="tooltip"]').tooltip();
	$("#error").html('The requested url "' + window.location + '" was not found on this server!')
    $("article > div.content").fitVids({customSelector: "iframe[src^='http://www.youtube']"});
;});
