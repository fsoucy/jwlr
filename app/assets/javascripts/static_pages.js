$(document).ready(function() {
    $('#coins').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=17';
    });
    $('#bullion').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=14';
    });
    $('#watch').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=10';
    });
    $('#necklace').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=3';
    });
    $('#ring').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=2';
    });
    $('#jewelry').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=1';
    });
});
