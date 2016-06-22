function isValidAddress(dropoff)
{
    var bool = false;

    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: window.location.protocol + "//" + window.location.host + "/api/isStreetAddress?dropoff=" + dropoff,
	data: {},
	dataType: "json",
	success: function (result) {
	    if (parseInt(result[0]["valid"]) == 1)
	    {
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

function validDelivery()
{
    if (parseInt($('#need_exchange').val()) == 1)
    {
	$('.selection').hide();
	$('.method_selection').show();
	$('.instructions').append("<h3 class='valid_delivery'>However, you can't get a product delivered without Paypal.</h3>");
    }
}

function addInactivePayment()
{
    $('.deal_payment').addClass("inactive_form_element");
    $('.deal_payment_label').addClass("inactive_form_element");
    $('#deal_payment_method_id_1').removeClass("inactive_form_element");
    $('#deal_payment_method_id_1').prev().removeClass("inactive_form_element");
}

function removeInactivePayment()
{
    $('.deal_payment').removeClass("inactive_form_element");
    $('.deal_payment_label').removeClass("inactive_form_element");
}

function addInactiveDelivery()
{
    $('#deal_exchange_method_id_1').addClass("inactive_form_element");
    $('#deal_exchange_method_id_1').prev().addClass("inactive_form_element");
}

function removeInactiveDelivery()
{
    $('#deal_exchange_method_id_1').removeClass("inactive_form_element");
    $('#deal_exchange_method_id_1').prev().removeClass("inactive_form_element");
}


function countMethods(className)
{
    var count = 0;
    $(className).each(function() {
	count += 1;
    });
    return count;
}

function defaultSelected()
{
    if (countMethods('.deal_selling') == 1)
    {
	$('.deal_selling').prop('checked', true);
    }
    if (countMethods('.deal_exchange') == 1)
    {
	$('.deal_exchange').prop('checked', true);
    }
    if (countMethods('.deal_payment') == 1)
    {
	$('.deal_payment').prop('checked', true);
    }
}



function checkDelivery()
{
    var any_checked = false;
    $('.deal_payment_quick').each(function() {
	if ($(this).prop('checked'))
	{
	    any_checked = true;
	}
    });
    $('.deal_payment').each(function() {
	if ($(this).prop('checked'))
	{
	    any_checked = true;
	}
    });
    if (!($('#deal_payment_method_id_1').prop('checked')) && any_checked)
    {
	addInactiveDelivery();
    }
    else
    {
	removeInactiveDelivery();
    }
}

function checkPaypal()
{
    if ($('#deal_exchange_method_id_1').prop('checked'))
    {
	addInactivePayment();
    }
    else
    {
	removeInactivePayment();
    }
}

function updateDeals(location, form, completion)
{
    formData = {}
    $(form).find(':input').each(function() {
	if ($(this).attr('type') != "radio" || $(this).prop("checked"))
	{
	    formData[$(this).attr('name')] = $(this).val();
	}
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
    $('.valid_delivery').remove();
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

    $(document).on('click', '.not_ready', function(e) {
	e.preventDefault();
    });

    $(document).on('click', '.inactive_form_element', function(e) {
	e.preventDefault();
    });

    $(document).on('click', '#redirect_button', function() {
	redirectToPage();
    });

    $(document).on('click', '.methods :input', function() {
	if (!($(this).hasClass("inactive_form_element")))  //don't execute graying out if the clicked is grayed out
	{
	    checkDelivery();
	    checkPaypal();
	}
    });

    $(document).on('click', '.guide_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.guide_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    
    $(document).on('click', '.selling_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.selling_method_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    $(document).on('click', '.methods_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.method_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });
    
    $(document).on('click', '.exchange_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.exchange_method_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    $(document).on('click', '.payment_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.payment_method_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    $(document).on('click', '.completed_button', function() {
	$('.selection').hide();
	$('.instructions').show();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.completed_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    $(document).on('click', '.complaint_button', function() {
	$('.selection').hide();
	$('.instructions').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.complaint_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });

    $(document).on('click', '.cancel_button', function() {
	$('.selection').hide();
	$('.instructions').hide();
	$('.instructions_price_warning').remove();
	$('.methods_submission').remove();
	$('.cancel_selection').show();
	$('.valid_delivery').remove();
	addRedirectButton();
    });
    
    $(document).on('click', '.methods_form_button', function(e) {
	e.preventDefault();
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	var postLoc = '/deals/' + id.toString();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_method_selection", function() {
	    });
	    $('.exchange_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
		$('.instructions').append("<h3 class='methods_submission'>Congrats! You've successfully updated the methods of transaction.</h3>");
		redirectToPage();
		validDelivery();
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
		$('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
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
	    $('.exchange_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
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
	    $('.exchange_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
	    });
	    $('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
	    });
	    $('.payment_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function() {
	    });
	    $('.completed_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function() {
	    });
	    $('.guide_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function() {
	    });
	    $('.instructions').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function() {
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
	    $('.deals_form').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function() {
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
	    $('.deals_form').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function() {
		redirectToPage();
	    });
	});

    });

    $(document).on('click', '.dropoff_location', function(e) {
	e.preventDefault();
	if (isValidAddress($('#deal_dropoff').val()))
	{
	    var str = window.location.href;
	    var beginIndex = str.indexOf("deals/");
	    var id = str.substring(beginIndex + 6);
	    var postLoc = '/deals/' + id.toString();
	    updateDeals(postLoc, $(this).parent('h3').parent('form'), function() {
		$('.exchange_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function() {
		});
		$('.valid_address').remove();
	    });
	}
	else
	{
	    $('.instructions').append("<h3 class='valid_address'>Please enter a valid street address.</h3>");
	}

    });

    
    // if on deals page

    if ($('.deals_menu').length > 0)
    {
	redirectToPage();
	validDelivery();
	checkDelivery();
	checkPaypal();
	defaultSelected();
    }
});
