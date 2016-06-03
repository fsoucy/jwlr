function setMessages(message_data, append)
{
  var thing = message_data;
  var mine = '<div class="message_list_mine">' + '<span class="message_text">' + thing[0] + '</span><img class="message_image" src="' + thing[3] + '"></div>';
  var theirs = '<div class="message_list_theirs">' + '<img class="message_image" src="' + thing[3] + '">' +  '<span class="message_text">' + thing[0] + '</span></div>';
  if(append)
  {
    if(window.myname == thing[1])
    {
      $('#messages').append(mine);
    }
    else
    {
      $('#messages').append(theirs);
    }
  }
  else
  {
    if(window.myname == thing[1])
    {
      $('#messages').prepend(mine);
    }
    else
    {
      $('#messages').prepend(theirs);
    }
  }
}


function loadOnIndex(num_conversation, myname)
{

    window.page = 1;
    window.myname = myname;
    var urlString = window.location.href;
    window.conversation = num_conversation;
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "https://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
	data: {},
	dataType: "json",
	success: function (result) {
    results = result.reverse();
 	    changed = false;
	    for (res in results)
	    {
		thing = results[parseInt(res)];
    setMessages(thing, false);
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
	    window.interval = setInterval(refreshMessages, 3000);
	    window.page = window.page + 1;
	    $('.message_container').scrollTop(10000);
	},
	error: function (e){
	}
    });
}


function refreshMessages()
{
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "https://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=1",
	data: {},
	dataType: "json",
	success: function (result) {
	    results = result.reverse();
	    for (res in results)
	    {
		thing = results[parseInt(res)];
		if (window.time != null && window.time < thing[2])
		{
        setMessages(thing, true);
		    window.time = thing[2]
		    $('.message_container').scrollTop(10000000);
		}
	    }
	},
	error: function (e){
	}
    });
}

function refreshIndex()
{
  if($('.convo_index_page').length)
  {
    $.get("https://" + window.location.host + '/conversations/conversations_index', function(data) {
      $(".conversations_indexing").replaceWith($(data).find(".conversations_indexing"));
      $('.convo_index_page').click(function(e){
        if($('.convo_thing').length)
        {
          e.preventDefault();
          $('.convo_thing').remove();
          var id = $(this).children('a').children('.conversation_id').val();
          var myname = $('#myname').val();
          clearInterval(window.interval);
          $('.conversation_window').load("https://" + window.location.host + '/conversations/' + id + " .convo_thing", function() {
            loadOnIndex(parseInt(id), myname.toString());
          });
        }
      });
    });
  }
  else
  {
    clearInterval(window.interval2);
  }
}

$(document).ready(function()
{   
  window.interval2 = setInterval(refreshIndex, 10000);
    window.myname = $('#myname').val();
    $('#messages').bind('scroll', function(event) {
      if ($('#messages').scrollTop() < 10)
  {
      var results;
      $.ajax({
    type: "GET",// GET in place of POST
    contentType: "application/json; charset=utf-8",
    url: "https://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
    data: {},
    dataType: "json",
    success: function (result) {
        results = result.reverse();
        for (res in results)
        {
      thing = results[parseInt(res)];
      setMessages(thing, false);
        }
    },
    error: function (e){
    }
      });
      window.page = window.page + 1;
  }
    });

    if ($('#messages').length > 0)
    {
	    window.page = 1;
	    var urlString = window.location.href;
	window.conversation = parseInt($('#conversation_id').val());

	if (urlString.includes("conversations?id="))
	{
	    var index = urlString.indexOf("id=");
	    var realIndex = index + 3;
	    var convo = parseInt(urlString.substring(realIndex));
	    window.conversation = convo;
	    
	}
	   
	    $.ajax({
	      type: "GET",// GET in place of POST
	      contentType: "application/json; charset=utf-8",
	      url: "https://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
	      data: {},
	      dataType: "json",
	      success: function (result) {
		      results = result.reverse();
		      changed = false;
		      for (res in results)
		      {
		        thing = results[parseInt(res)];
            setMessages(thing, false);
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
	        window.interval = setInterval(refreshMessages, 3000);
		      window.page = window.page + 1;
		      $('.message_container').scrollTop(10000);
	      },
	      error: function (e){
	      
        }
	    });
    }
    else
    {
	    clearInterval(window.interval);
    }

    
    $(document).keydown(function(event) {
	if (event.which == 13 && $('#message_input').val().length > 0)
	{
	    
	    event.preventDefault();
	    var result = $.post('/messages', $('#message_form').serialize());
	    refreshMessages();
	    $('.message_container').scrollTop(10000000);
	    $('#message_input').val('');
	}
    });

        
    $(document).on('click', '#message_submit', function(event) {
	event.preventDefault();
	$.post('/messages', $('#message_form').serialize());
	refreshMessages();
	$('.message_container').scrollTop(10000000);
	$('#message_input').val('');

    });
    
    $('.convo_index_page').click(function(e){
      if($('.convo_thing').length > 0)
      {
        e.preventDefault();
	  $('.convo_thing').remove();
	  var id = $(this).children('a').children('.conversation_id').val();
        var myname = $('#myname').val();
        clearInterval(window.interval);
        $('.conversation_window').load("https://" + window.location.host + '/conversations/' + id + " .convo_thing", function() {
	        loadOnIndex(parseInt(id), myname.toString());
	        $('#messages').bind('scroll', function(event) {
            if ($('#messages').scrollTop() < 10)
            {
              var results;
              $.ajax({
                type: "GET",// GET in place of POST
                contentType: "application/json; charset=utf-8",
                url: "https://" + window.location.host + "/conversations/" + window.conversation + "/pull_messages?page=" + window.page.toString(),
                data: {},
                dataType: "json",
                success: function (result) {
                  results = result.reverse();
                  for (res in results)
                  {
                    thing = results[parseInt(res)];
                    setMessages(thing, false);
                  }
                },
                error: function (e){
                }
              });
              window.page = window.page + 1;
            }
	        });
	      });
      }
    });
});

