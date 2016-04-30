$(document).ready(function() {
    $('.notification').hover(function() {
	var str = $(this).children('.edit_notification').children('.notification_id').val();
	console.log(str);
	var place = '/users/2/notifications/' + str;
	$.post(place, $(this).children('form').serialize());
    });
});
