

function displaceFlashNotifications()
{
    var count = 0;
    $('.flash_note').each(function(index, data) {
	var distance = count * 120
	$(this).css("margin-top", distance.toString() + "px");
	count += 1;
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

    $('.sees_notification').click(function(e) {
	var str = "#notification" + $(this).attr("id").substring("notification".length);
	var $form = $(str);
	debugger;
	var place = '/users/' + $('#user_id').val() + '/notifications/' + $(this).attr("id").substring("notification".length);
	$.post(place, $form.serialize());
    });
    
    displaceFlashNotifications();
    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
