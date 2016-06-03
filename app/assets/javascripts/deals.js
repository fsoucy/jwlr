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

function updateDeals(location, form, completion)
{
    formData = {}
    debugger;
    $(form).find(':input').each(function() {
	formData[$(this).attr('name')] = $(this).val();
    });
    $.ajax({
	type: "PATCH",// GET in place of POST
	url: location,
	data: formData,
	success: function (result) {
	    completion();
	},
	error: function (e){
	}
    });
}


function redirectToPage()
{
    $('#redirect_button').hide();
    var page = parseInt($('#page').val());
    $('.selection').hide();
    if (page == 1)
    {
	$('.instructions').show();
	$('.method_selection').show();
    }
    else if (page == 2)
    {
	$('.instructions').show();
	$('.selling_method_selection').show();
    }
    else if (page == 3)
    {
	$('.instructions').show();
	$('.exchange_method_selection').show();
    }
    else if (page == 4)
    {
	$('.instructions').show();
	$('.completed_selection').show();
    }
}

function getCurrentPage()
{
    var page = 0;
    if ($(".method_selection").is(":visible"))
    {
	page = 1;
    }
    if ($(".selling_method_selection").is(":visible"))
    {
	page = 2;
    }
    if ($(".exchange_method_selection").is(":visible"))
    {
	page = 3;
    }
    if ($(".completed_selection").is(":visible"))
    {
	page = 4;
    }
    if ($(".complaint_selection").is(":visible"))
    {
	page = 5;
    }
    // if none are visible, then a complaint has been filed and page = 0
    // if page is 0, don't render button
    return page;
}

function isRightPage()
{
    var actionPage = parseInt($('#page').val());
    var currentPage = getCurrentPage();
    return (currentPage == 0) || (actionPage == currentPage);
}

function addRedirectButton() //if necessary of course
{
    if (isRightPage())
    {
	$('#redirect_button').hide();
    }
    else
    {
	$('#redirect_button').show();
    }
    
}

// if not right page, add special button "Lost?"
// all that button does is call redirectToPage()

$(document).ready(function() {
    $('.selection').hide();
    $('.method_selection').show();

    $(document).on('click', '#redirect_button', function() {
	redirectToPage();
    });

    $(document).on('click', '.guide_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.guide_selection').show();
	addRedirectButton();
    });

    
    $(document).on('click', '.selling_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.selling_method_selection').show();
	addRedirectButton();
    });

    $(document).on('click', '.methods_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.method_selection').show();
	addRedirectButton();
    });
    
    $(document).on('click', '.exchange_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.exchange_method_selection').show();
	addRedirectButton();
    });

    $(document).on('click', '.payment_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.payment_method_selection').show();
	addRedirectButton();
    });

    $(document).on('click', '.completed_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.completed_selection').show();
	addRedirectButton();
    });

    $(document).on('click', '.complaint_button', function() {
	$('.selection').hide();
	$('.instructions').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submittion').remove();
	$('.complaint_selection').show();
	addRedirectButton();
    });
    
    $(document).on('click', '.methods_form_button', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	debugger;
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
		$('.instructions').append("<h3 class='methods_submission'>Congrats! You've successfully updated the methods of transaction.</h3>");
		redirectToPage();
	    });
	});
    });

    $(document).on('submit', '.price_submission', function(e) {
	e.preventDefault();
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
	    var str = window.location.href;
	    var beginIndex = str.indexOf("deals/");
	    var id = str.substring(beginIndex + 6);
	    var postLoc = '/deals/' + id.toString();
	    updateDeals(postLoc, $(this), function() {
		$('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
		});
	    });
	}
    });
    
    $(document).on('click', '.deals_form_button', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.deals_form_button_accept_price', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('h3').parent('form'), function() {
	    $('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.deals_form_button_in_header', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('h3').parent('form'), function() {
	    $('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.file_complaint_button', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.deals_form').load("http://" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function() {
	    });
	});
    });

    $(document).on('click', '.remove_complaint_button', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.deals_form').load("http://" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function() {
		redirectToPage();
	    });
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
	    updateDeals(postLoc, $(this).parent('form'), function() {
		$('.exchange_method_selection').load("http://" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
		});
		$('.valid_address').remove();
	    });
	}
	else
	{
	    $('.instructions').append("<h3 class='valid_address'>Please enter a valid street address.</h3>");
	}

    });

    

    redirectToPage();
    

});
