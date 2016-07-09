
function addUnreadToFlash(dict)
{
    var id = "#notification_flash" + dict["id"];
    if ($(id).length == 0)
    {
	var content = "<div class='flash_note'><a href='" + dict["url"] + "' class='sees_notification_flash' id='notification_flash" + dict["id"] + "'>" +
	    dict["message"] + "</a>\n<h4>" + dict["time_ago"] + " ago</h4>\n<h4 class='close_notification sees_notification_close' id='notification_close'" +
	    dict["id"] + "'>Close</h4>\n</div>";
	$('.content').prepend(content);
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

function getNewFlashNotifications()
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
		addUnreadToFlash(result[i]);
		displaceFlashNotifications();
	    }
	},
    });
}

$(document).ready(function() {
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
	$(this).parent().remove();
	displaceFlashNotifications();
    });

    $('.sees_notification').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification".length);
	$.post(place, $form.serialize());
    });

    $('.sees_notification_flash').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification_flash".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_flash".length);
	console.log(place);
	$.post(place, $form.serialize());
    });

    $('.sees_notification_close').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification_close".length);
	var $form = $(str);
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification_close".length);
	$.post(place, $form.serialize());
    });
    
    displaceFlashNotifications();
    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
