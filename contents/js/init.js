$(function() {
	$.getJSON('https://api.github.com/users/magicmonty/repos?callback=?', function(resp) {
		if (resp.data.length > 0) {
			$('#github-repos').append('<ul></ul>');
			$.each($(resp.data).sort('pushed_at', 'desc'), function(i, val) {
				var description = ((val['description']) ? val['description'] : '(No description.)');
				var url = val['html_url'];
				var name = val['name'];
				var selector = "github_" + name;

				$('#github-repos > ul').append(
					'<li><a href="'+url+'" title="'+name+'" rel="popover" data-placement="left" data-trigger="hover" data-content="'+description+'" class="github_link" id="github_link_' + name + '" >'+name+'</a></li>');
			});			
		} else {
			$('#github-repos').append('<p>No public repositories.</p>');
		}
		
		$('a[rel="popover"]').popover();
	});	
	
	$('*[rel="tooltip"]').tooltip();
});
