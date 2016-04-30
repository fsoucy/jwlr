$(document).ready(function() {
    $('.notification').hover(function() {

	if ($(this).children('.read').length > 0)
	{
	    console.log('read');
	}
	else
	{
	    var str = $(this).children('.edit_notification').children('.n\
otification_id').val();
	    var place = '/users/2/notifications/' + str;
	    $.post(place, $(this).children('form').serialize());
	    $(this).children('p').removeClass("not_read").addClass("read");
	    $(this).removeClass('notification_not_read').addClass('notification_read');
	}
    });

    $('.read').parent('.notification').addClass('notification_read');
    $('.not_read').parent('.notification').addClass('notification_not_read');
});
