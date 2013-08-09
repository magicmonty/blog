require('./lib/jquery-2.0.3.min');
require('./lib/bootstrap.min');

$(function() {
	require('./lib/jquery.fitvids').init();

	$('*[rel="popover"]').popover();
	$('*[rel="tooltip"]').tooltip();
	$("#error").html('The requested url "' + window.location + '" was not found on this server!')
    $("article > div.content").fitVids();
    $("div.date > span").each(function () {
        $(this).html(require('./lib/date')($(this).data("date")));
    });

	require('./lib/blanklinks')();
;});
