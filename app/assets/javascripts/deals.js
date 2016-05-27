function isValidAddress(dropoff)
{
    var bool = false;
    debugger;
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "http://" + window.location.host + "/api/isStreetAddress?dropoff=" + dropoff,
	data: {},
	dataType: "json",
	success: function (result) {
	    debugger;
	    if (parseInt(result[0]["valid"]) == 1)
	    {
		debugger;
		bool = true;
	    }
	    else
	    {
	    }
	},
	async: false
    });
    return bool;
}


function redirectToPage()
{
    var page = parseInt($('#page').val());
    $('.selection').hide();
    if (page == 1)
    {
	$('.method_selection').show();
    }
    else if (page == 2)
    {
	$('.selling_method_selection').show();
    }
    else if (page == 3)
    {
	$('.exchange_method_selection').show();
    }
    else if (page == 4)
    {
	$('.completed_selection').show();
    }
}

$(document).ready(function() {
    $('.selection').hide();
    $('.method_selection').show();


    $(document).on('click', '.guide_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.guide_selection').show();
    });

    
    $(document).on('click', '.selling_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.selling_method_selection').show();
    });

    $(document).on('click', '.methods_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.method_selection').show();
    });

    $(document).on('click', '.exchange_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.exchange_method_selection').show();
    });

    $(document).on('click', '.payment_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.payment_method_selection').show();
    });

    $(document).on('click', '.completed_button', function() {
	$('.selection').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.completed_selection').show();
    });


    
    $(document).on('click', '.methods_form_button', function(e) {
	e.preventDefault();

	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	$('.instructions').append("<h3 class='methods_submission'>Congrats! You've successfully updated the methods of transaction.</h3>");
	$.post(postLoc, $(this).parent('form').serialize());
	$('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .exchange_method_selection", function() {
	});
	$('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .selling_method_selection", function() {
	});
	$('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .payment_method_selection", function() {
	});
	$('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .completed_selection", function() {
	});
	$('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    redirectToPage();
	});
    });

    $(document).on('submit', '.price_submission', function(e) {
	e.preventDefault();
	debugger;
	if (parseFloat($('#price_proposal').val()) < parseFloat($('#minimum_price').val()))
	{
	    $('#price_proposal').addClass('price_warning');
	    $('.instructions_price_warning').remove();
	    $('.instructions').append("<h3 class='instructions_price_warning'>Price offer too low.</h3");
	}
	else
	{
	    $('.instructions_price_warning').remove();
	    $('#price_proposal').removeClass('price_warning');
	}
    });
    
    $(document).on('click', '.deals_form_button', function(e) {
	e.preventDefault();
	
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	debugger;
	var postLoc = '/deals/' + id.toString();
	$.post(postLoc, $(this).parent('form').serialize());
	$('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .exchange_method_selection", function() {
	});
	$('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .selling_method_selection", function() {
	});
	$('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .payment_method_selection", function() {
	});
	$('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .completed_selection", function() {
	});
	$('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    redirectToPage();
	});
    });

    $(document).on('click', '.dropoff_button', function(e) {
	e.preventDefault();
	if (isValidAddress($('#deal_dropoff').val()))
	{
	    var str = window.location.href;
	    var beginIndex = str.indexOf("deals/");
	    var id = str.substring(beginIndex + 6);
	    var postLoc = '/deals/' + id.toString();
	    $.post(postLoc, $(this).parent('form').serialize());
	    $('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .exchange_method_selection", function() {
	    });
	    $('.valid_address').remove();
	}
	else
	{
	    $('.instructions').append("<h3 class='valid_address'>Please enter a valid street address.</h3>");
	}

    });

    

    redirectToPage();
    

});
