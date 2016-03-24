$(document).ready(function() {
    $('.massage_container').scrollTop(10000000);
    var page = 1;
    $('.massage_container').scroll(function(event) {
	if ($('.massage_container').scrollTop() < 10)
	{
	    var results;
	    $.ajax({
		type: "GET",// GET in place of POST
		contentType: "application/json; charset=utf-8",
		url: "http://" + window.location.host + "/conversations/8/pull_messages?page=" + page,
		data: {},
		dataType: "json",
		success: function (result) {
		    results = result;
		},
		error: function (e){
		}
	    });
	    for (result in results)
	    {
	    }
	    page = page + 1;
	}
    });
});
