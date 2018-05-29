jQuery(function () {

  jQuery('*[rel="popover"]').popover();
  jQuery('*[rel="tooltip"]').tooltip();
  jQuery("#error").html('The requested url "' + window.location + '" was not found on this server!')
  jQuery("div.date > span").each(function () {
    jQuery(this).html(moment(jQuery(this).data("date")).fromNow());
  });

  window.idx = lunr(function () {
    this.field('id');
    this.field('title', { boost: 10 });
    this.field('author');
    this.field('category');
  });

  window.data = jQuery.getJSON('/search_data.json');

  window.data.then(function(loaded_data){
    jQuery.each(loaded_data, function(index, value){
      window.idx.add(
        jQuery.extend({ "id": index }, value)
      );
    });
  });

  // Event when the form is submitted
  jQuery("#site_search").submit(function(event){
      event.preventDefault();
      var query = jQuery("#search_box").val(); // Get the value for the text field
      var results = window.idx.search(query); // Get lunr to perform a search
      display_search_results(results); // Hand the results off to be displayed
  });

  function display_search_results(results) {
    var $search_results = $("#search_results");

    // Wait for data to load
    window.data.then(function (loaded_data) {

      // Are there any results?
      if (results.length) {
        $search_results.empty(); // Clear any old results
        $search_results.append("<h2>Search results</h2><ul>");

        // Iterate over the results
        results.forEach(function (result) {
          var item = loaded_data[result.ref];

          // Build a snippet of HTML for this result
          var appendString = '<li><a href="' + item.url + '">' + item.title + '</a></li>';

          // Add it to the results
          $search_results.append(appendString);
        $search_results.append("</ul>");
        });
      } else {
        $search_results.html('<h2>Search results</h2>No results found');
      }
    });
  }
});
