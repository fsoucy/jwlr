$(document).ready(function() {
    $('.selection').hide();
    $('.method_selection').show();

    $('.guide_button').click(function() {
	$('.selection').hide();
	$('.guide_selection').show();
    });
    
    $('.selling_button').click(function() {
	$('.selection').hide();
	$('.selling_method_selection').show();
    });

    $('.methods_button').click(function() {
	$('.selection').hide();
	$('.method_selection').show();
    });

    $('.exchange_button').click(function() {
	$('.selection').hide();
	$('.exchange_method_selection').show();
    });
    
    $('.payment_button').click(function() {
	$('.selection').hide();
	$('.payment_method_selection').show();
    });

    $('.completed_button').click(function() {
	$('.selection').hide();
	$('.completed_selection').show();
    });
});
