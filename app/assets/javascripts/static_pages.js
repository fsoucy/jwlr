$(document).ready(function() {
    $('#coins').click(function() {
	window.location.href += 'search?' + '&category_id=60';
    });
    $('#bullion').click(function() {
	window.location.href += 'search?' + '&category_id=59';
    });
    $('#watch').click(function() {
	window.location.href += 'search?' + '&category_id=20';
    });
    $('#necklace').click(function() {
	window.location.href += 'search?' + '&category_id=8';
    });
    $('#ring').click(function() {
	window.location.href += 'search?' + '&category_id=7';
    });
    $('#jewelry').click(function() {
	window.location.href += 'search?' + '&category_id=1';
    });
});
