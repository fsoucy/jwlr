$(document).ready(function() {
    $('.massage_container').scrollTop(10000000);
    window.page = 2;
    $('.massage_container').scroll(function(event) {
	if ($('.massage_container').scrollTop() < 10)
	{
	    var results;
	    $.ajax({
		type: "GET",// GET in place of POST
		contentType: "application/json; charset=utf-8",
		url: "http://" + window.location.host + "/conversations/8/pull_messages?page=" + window.page.toString(),
		data: {},
		dataType: "json",
		success: function (result) {
		    results = result.reverse();
		    for (res in results)
		    {
			thing = results[parseInt(res)];
			$('.massages').prepend('<li>' + thing[1] + ': ' + thing[0] + ',' + thing[2] + '</li>');
		    }
		},
		error: function (e){
		}
	    });
	    window.page = window.page + 1;
	}
    });
});
