//hard coded for conversation 8


function loadOnIndex(num_conversation)
{

    window.page = 1;
    var urlString = window.location.href;
    window.conversation = num_conversation;
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "http://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
	data: {},
	dataType: "json",
	success: function (result) {
	    results = result.reverse();
	    changed = false;
	    for (res in results)
	    {
		thing = results[parseInt(res)];
		$('.massages').prepend('<li class="message_list">' + '<img class="message_image" src="' + thing[3] + '">' +  '<span class="message_text">' + thing[1] + ': ' + thing[0] + '</span></li>');
		if (!changed)
		{
		    changed = true;
		    window.time = thing[2];
		}
	    }
	    if (window.time == null)
	    {
		window.time = new Date().getTime() / 1000;
	    }
	    window.interval = setInterval(refreshMessages, 1000);
	    window.page = window.page + 1;
	    $('.massage_container').scrollTop(10000);
	},
	error: function (e){
	}
    });
}


function refreshMessages()
{
    //$(".massage_container").load('http://igold.ws:3000/conversations/8' + " .massages");
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "http://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=1",
	data: {},
	dataType: "json",
	success: function (result) {
	    results = result.reverse();
	    for (res in results)
	    {
		thing = results[parseInt(res)];
		if (window.time != null && window.time < thing[2])
		{
		    $('.massages').append('<li class="message_list">' + '<img class="message_image" src="' + thing[3] + '">' + '<span class="message_text">' + thing[1] + ': ' + thing[0] + '</span></li>');
		    window.time = thing[2]
		    $('.massage_container').scrollTop(10000000);
		}
	    }
	},
	error: function (e){
	}
    });
}

$(document).ready(function()
{   

    if ($('.massages').length > 0)
    {
	window.page = 1;
	var urlString = window.location.href;
	window.conversation = parseInt($('#conversation_id').val());
	$.ajax({
	    type: "GET",// GET in place of POST
	    contentType: "application/json; charset=utf-8",
	    url: "http://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
	    data: {},
	    dataType: "json",
	    success: function (result) {
		results = result.reverse();
		changed = false;
		for (res in results)
		{
		    thing = results[parseInt(res)];
		    $('.massages').prepend('<li class="message_list">' + '<img class="message_image" src="' + thing[3] + '">' +  '<span class="message_text">' + thing[1] + ': ' + thing[0] + '</span></li>');
		    if (!changed)
		    {
			changed = true;
			window.time = thing[2];
		    }
		}
		if (window.time == null)
		{
		    window.time = new Date().getTime() / 1000;
		}
	        window.interval = setInterval(refreshMessages, 1000);
		window.page = window.page + 1;
		$('.massage_container').scrollTop(10000);
	    },
	    error: function (e){
	    }
	});
    }
    else
    {
	clearInterval(window.interval);
    }

    $('.massage_container').scroll(function(event) {
	if ($('.massage_container').scrollTop() < 10)
	{
	    var results;
	    $.ajax({
		type: "GET",// GET in place of POST
		contentType: "application/json; charset=utf-8",
		url: "http://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
		data: {},
		dataType: "json",
		success: function (result) {
		    results = result.reverse();
		    for (res in results)
		    {
			thing = results[parseInt(res)];
			$('.massages').prepend('<li class="message_list">' + '<img class="message_image" src="' + thing[3] + '">' + '<span class="message_text">' + thing[1] + ': ' + thing[0] + '</span></li>');
			//window.time = thing[2];
		    }
		},
		error: function (e){
		}
	    });
	    window.page = window.page + 1;
	}
    });
    
    $(document).keydown(function(event) {
	if (event.which == 13 && $('#message_input').val().length > 0)
	{
	    
	    event.preventDefault();
	    var result = $.post('/messages', $('#message_form').serialize());
	    refreshMessages();
	    //$(".massage_container").load('http://igold.ws:3000/conversations/8' + " .massages");
	    $('.massage_container').scrollTop(10000000);
	    $('#message_input').val('');
	}
    });
    
    $('#message_submit').click(function(event) {
	debugger;
	event.preventDefault();
	$.post('/messages', $('#message_form').serialize());
	//$(".massages").load('http://igold.ws:3000/conversations/8' + " .massages");
	refreshMessages();
	$('.massage_container').scrollTop(10000000);
	$('#message_input').val('');
    });
    
    
    
    $('.convo_index_page').click(function(e){
	e.preventDefault();
	$('.convo_thing').remove();
	var id = $(this).children('a').children('.conversation_id').val();
	$(this).siblings('.big').load("http://" + window.location.host + '/conversations/' + id + " .convo_thing", function() {
	    loadOnIndex(parseInt(id));
	});
    });
});

