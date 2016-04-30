$(document).ready(function() {
    $('.notification').hover(function() {
	var str = $(this).children('.edit_notification').children('.notification_id').val();
	console.log(str);
	var place = '/notifications/' + str;
	debugger;
	$.post(place, $(this).children('form').serialize());
    });
});
