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
	if ($('#deal_exchange_method_id_1').length > 0 && $('#deal_exchange_method_id_1').prop('checked'))
	{
	    $('#deal_payment_method_id_1').prop('checked', true);
	}
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
    if ($('.cancel_selection').is(":visible"))
    {
	page = 6;
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

function refreshAll(completion)
{
    var str = window.location.href;
    var beginIndex = str.indexOf("deals/");
    var id = str.substring(beginIndex + 6);
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
	completion();
    });

}

function refreshDeals()
{
    var str = window.location.href;
    var beginIndex = str.indexOf("deals/");
    var id = str.substring(beginIndex + 6);
    var updated_at = parseInt($('#updated_at').val());
    $.ajax({
      type: "GET",// GET in place of POST
      url: window.location.protocol + "//" + window.location.host + "/deals/" + id.toString() + "/updated_at",
      success: function(result) {
          if(result > updated_at)
          {
	      refreshAll(function() {
		  addRedirectButton();
	      });
	  }
      }
    });
}

function swapPage(showInstructions, toShow)
{
    $('.selection').hide();
    $('.instructions_price_warning').remove();
    $('.methods_submission').remove();
    $('.valid_delivery').remove();
    if (showInstructions)
    {
	$('.instructions').show();
    }
    else
    {
	$('.instructions').hide();
    }
    $(toShow).show();
    addRedirectButton();
}


function getPostLoc()
{
    var str = window.location.href;
    var beginIndex = str.indexOf("deals/");
    var id = str.substring(beginIndex + 6);
    var postLoc = '/deals/' + id.toString();
    return postLoc;
}

// if not right page, add special button "Lost?"
// all that button does is call redirectToPage()

$(document).ready(function() {

    if ($('#on_the_deals_page').length > 0 && parseInt($('#on_the_deals_page').val()) == 1) //on deals
    {
	// refresh deals panel on an interval
	window.dealsInterval = setInterval(refreshDeals, 3000);
    }
    else
    {
	// clear deals interval
	clearInterval(window.dealsInterval);
    }
    
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
	swapPage(true, '.guide_selection');
    });

    
    $(document).on('click', '.selling_button', function() {
	swapPage(true, '.selling_method_selection');
    });

    $(document).on('click', '.methods_button', function() {
	swapPage(true, '.method_selection');
    });
    
    $(document).on('click', '.exchange_button', function() {
	swapPage(true, '.exchange_method_selection');
    });

    $(document).on('click', '.payment_button', function() {
	swapPage(true, '.payment_method_selection');
    });

    $(document).on('click', '.completed_button', function() {
	swapPage(true, '.completed_selection');
    });

    $(document).on('click', '.complaint_button', function() {
	swapPage(false, '.complaint_selection');
    });

    $(document).on('click', '.cancel_button', function() {
	swapPage(false, '.cancel_selection');
    });
    
    $(document).on('click', '.methods_form_button', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
	updateDeals(postLoc, $(this).parent('h3').parent('form'), function() {
	    refreshAll(function(){
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
	    var postLoc = getPostLoc();
	    updateDeals(postLoc, $(this), function() {
		$('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function() {
		});
	    });
	}
    });
    
    $(document).on('click', '.deals_form_button', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    refreshAll(function(){
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.deals_form_button_accept_price', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
	updateDeals(postLoc, $(this).parent('h3').parent('form'), function() {
	    refreshAll(function(){
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.deals_form_button_in_header', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    refreshAll(function(){
		redirectToPage();
	    });
	});
    });

    $(document).on('click', '.file_complaint_button', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
	updateDeals(postLoc, $(this).parent('form'), function() {
	    $('.deals_form').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function() {
	    });
	});
    });

    $(document).on('click', '.remove_complaint_button', function(e) {
	e.preventDefault();
	var postLoc = getPostLoc();
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
	    var postLoc = getPostLoc();
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
