


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

    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
