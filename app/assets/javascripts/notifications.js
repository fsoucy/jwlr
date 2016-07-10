
function addUnreadToFlash(dict)
{
    if ($('.flash_notifications').length > 0)
    {
	var id = "#notification_flash" + dict["id"];
	if ($(id).length == 0)
	{
	    console.log('should add it');
	    var content = "<div class='flash_note'><a href='" + dict["url"] + "' class='sees_notification_flash' id='notification_flash" + dict["id"] + "'>" +
		dict["message"] + "</a>\n<h4>" + dict["time_ago"] + " ago</h4>\n<h4 class='close_notification sees_notification_close' id='notification_close'" +
		dict["id"] + "'>Close</h4>\n</div>";
	    $('.flash_notifications').append(content);
	}
    }
}

function generateDropdownItem(dict)
{
    if ($('.flash_notifications').length> 0)
    {
	var message = dict["message"];
	if (message.length > 15)
	{
	    message = message.substring(0, 12) + "...";
	}
	return "<li class='pure-menu-item unread_notification'><a href='" + dict["url"] + "' class='pure-menu-link sees_notification_drop' id='notification_drop" + dict["id"]
	    + "'>" + message + "</a></li>";
    }
}

function addUnreadToDropdown(dict)
{
    var id = "#notification_drop" + dict["id"];
    if (($('.read_notification').length == 0) || (($(id).length > 0) && $(id).parent().hasClass('unread_notification')))
    {
	//do nothing
	console.log(id);
	console.log('nothing');
    }
    else
    {
	console.log(id);
	if ($(id).length > 0)
	{
	    $(id).remove();
	}
	else
	{
	    $('.read_notification').last().remove();
	}
	$('.notifications_dropdown').prepend(generateDropdownItem(dict));
	var count = parseInt($('#unread_count').text());
	console.log("plus one");
	$('#unread_count').text((count + 1).toString());
	addUnreadToFlash(dict);
	displaceFlashNotifications();
    }
}

function displaceFlashNotifications()
{
    var count = 0;
    $('.flash_note').each(function(index, data) {
	var distance = count * 120
	$(this).css("margin-top", distance.toString() + "px");
	count += 1;
    });
}

function getNewNotifications()
{
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: window.location.protocol + "//" + window.location.host + "/api/getUnreadNotifications?user_id=2",
	data: {},
	dataType: "json",
	success: function (result) {
	    for (var i = 0; i < result.length; i++)
	    {
		addUnreadToDropdown(result[i]);
	    }
	},
    });
}

$(document).ready(function() {
    window.interval3 = setInterval(getNewNotifications, 10000);
    $('.notification').hover(function() {

	if ($(this).children('.read').length > 0)
	{
	}
	else
	{
	    var str = $(this).children('.notification_seen').children('.n\
otification_id').val();
	    var place = '/users/' + $('#user_id').val() + '/notifications/' + str;
	    $.post(place, $(this).children('.notification_seen').serialize());
	}
    });

    $('.notification a').click(function(e) {
	var str = $(this).parent().siblings('.notification_viewed').children('.notification_id').val();
	var place = '/users/' + $('#user_id').val() + '/notifications/' + str;
	console.log(place);
	$.post(place, $(this).parent().siblings('.notification_viewed').serialize());
    });

    /*
    $('.sees_notification').click(function(e) {
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification".length);
	$.ajax({
	    type: "POST",
	    contentType: "application/json; charset=utf-8",
	    url: window.location.protocol + "//" + window.location.host + place,
	    data: {read: true},
	    dataType: "json",
	    success: function (result) {
	    },
	    error: function (e){
	    }
	});
    });
    */

    $('.close_notification').click(function() {
	$(this).parent().hide();
	displaceFlashNotifications();
    });

    $('.sees_notification').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification".length);
	$.post(place, $form.serialize());
    });

    $('.sees_notification_flash').click(function(e) {
	var str = "#note_drop" + $(this).attr("id").substring("notification_flash".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_flash".length);
	console.log(place);
	$.post(place, $form.serialize());
    });

    $('.sees_notification_close').click(function(e) {
	var str = "#note_drop" + $(this).attr("id").substring("notification_close".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_close".length);
	$.post(place, $form.serialize());
    });

    $('.sees_notification_drop').click(function(e) {
	var str = "#note_drop" + $(this).attr("id").substring("notification_drop".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_drop".length);
	$.post(place, $form.serialize());
    });
    
    displaceFlashNotifications();
    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
