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


    $('.deals_form_button').click(function() {
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = beginIndex.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	$.post(postLoc, $('.edit_deal').serialize());
	$('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .exchange_method_selection", function() {
	});
	$('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .selling_method_selection", function() {
	});
	$('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .payment_method_selection", function() {
	});
	$('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .completed_selection", function() {
	});
	$('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	});
    });
});
