
function addUnreadToFlash(dict)
{
    if ($('.flash_notifications').length > 0)
    {
	var id = "#notification_flash" + dict["id"];
	if ($(id).length == 0)
	{
	    console.log('should add it');
	    var content = "<div class='flash_note'><a href='" + dict["url"] + "' class='sees_notification_flash' id='notification_flash" + dict["id"] + "'>" +
		dict["message"] + "</a>\n<h4>" + dict["time_ago"] + " ago</h4>\n<h4 class='close_notification sees_notification_close' id='notification_close" +
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
    var user_id = $('#user_id').val();
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: window.location.protocol + "//" + window.location.host + "/api/getUnreadNotifications?user_id=" + user_id,
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

function notificationSeen(urlLocation)
{
    $.ajax({
	url: urlLocation,
	type: "PATCH",
	context: this,
	data: {notification: {read: true}},
	success: function (result) {
	},
	error: function (e){
	}
    });
}

function notificationViewed(urlLocation)
{
    $.ajax({
	url: urlLocation,
	type: "PATCH",
	context: this,
	data: {notification: {read: true, viewed: true}},
	success: function (result) {
	},
	error: function (e){
	}
    });
}

$(document).ready(function() {
    window.interval3 = setInterval(getNewNotifications, 10000);
    $('.notification').hover(function() {
	var str = "";
	if ($(this).children('.read').length > 0)
	{
	}
	else
	{
	    str = $(this).children(".notification_id").val();
	    var place = '/users/' + $('#user_id').val() + '/notifications/' + str;
	    notificationSeen(place);
	}
	var unseen = $('#unread_count').text()
	var unread = parseInt(unseen) - 1
	if (unread >= 0)
	{
	    $('#unread_count').text(unread.toString());
	}
	var thing = "#notification_drop" + str;
	$(thing).parent().removeClass("unread_notification").addClass("read_notification");
	
	
    });

    $('.notification a').click(function(e) {
	e.preventDefault();
	var str = $(this).parent().siblings('.notification_viewed').children('.notification_id').val();
	var place = '/users/' + $('#user_id').val() + '/notifications/' + str;
	notificationViewed(place);
	window.location.href = $(this).attr('href');
    });


    $(document).on('click', '.close_notification', function(e) {
	$(this).parent().remove();
	displaceFlashNotifications();
    });

    
    $('.sees_notification').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification".length);
	notificationViewed(place);
    });

    $(document).on('click', '.sees_notification_flash', function(e) {
	e.preventDefault();
	var str = "#note_drop" + $(this).attr("id").substring("notification_flash".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_flash".length);
	notificationViewed(place);
	window.location.href = $(this).attr('href');
    });

    $(document).on('click', '.sees_notification_close', function(e) {
	var str = "#note_drop" + $(this).attr("id").substring("notification_close".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_close".length);
	var currentCount = parseInt($('#unread_count').text()) - 1;
	$('#unread_count').text(currentCount.toString());
	var dropId = "#notification_drop" + $(this).attr("id").substring("notification_close".length);
	$(dropId).parent().removeClass("unread_notification").addClass("read_notification");
	notificationViewed(place);
	displaceFlashNotifications();
    });

    $(document).on('click', '.sees_notification_drop', function(e) {
	e.preventDefault();
	var str = "#note_drop" + $(this).attr("id").substring("notification_drop".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_drop".length);
	notificationViewed(place);
	window.location.href = $(this).attr('href');
    });
    
    displaceFlashNotifications();
    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
