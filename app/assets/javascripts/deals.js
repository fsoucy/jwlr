function isValidAddress(dropoff) {
	var bool = false;

	$.ajax({
		type : "GET", // GET in place of POST
		contentType : "application/json; charset=utf-8",
		url : window.location.protocol + "//" + window.location.host + "/api/isStreetAddress?dropoff=" + dropoff,
		data : {},
		dataType : "json",
		success : function (result) {
			if (parseInt(result[0]["valid"]) == 1) {
				bool = true;
			} else {}
		},
		async : false
	});
	return bool;
}

function validDelivery() {
	if (parseInt($('#need_exchange').val()) == 1) {
		$('.method_selection').show();
		$('.instructions').append("<h3 class='valid_delivery'>However, you can't get a product delivered without Paypal.</h3>");
	}
}

function addInactivePayment() {
	$('.deal_payment').addClass("inactive_form_element");
	$('.deal_payment_label').addClass("inactive_form_element");
	$('#deal_payment_method_id_1').removeClass("inactive_form_element");
	$('#deal_payment_method_id_1').prev().removeClass("inactive_form_element");
}

function removeInactivePayment() {
	$('.deal_payment').removeClass("inactive_form_element");
	$('.deal_payment_label').removeClass("inactive_form_element");
}

function addInactiveDelivery() {
	$('#deal_exchange_method_id_1').addClass("inactive_form_element");
	$('#deal_exchange_method_id_1').prev().addClass("inactive_form_element");
}

function removeInactiveDelivery() {
	$('#deal_exchange_method_id_1').removeClass("inactive_form_element");
	$('#deal_exchange_method_id_1').prev().removeClass("inactive_form_element");
}

function countMethods(className) {
	var count = 0;
	$(className).each(function () {
		count += 1;
	});
	return count;
}

function defaultSelected() {
	if (countMethods('.deal_selling') == 1) {
		$('.deal_selling').prop('checked', true);
	}
	if (countMethods('.deal_exchange') == 1) {
		$('.deal_exchange').prop('checked', true);
		if ($('#deal_exchange_method_id_1').length > 0 && $('#deal_exchange_method_id_1').prop('checked')) {
			$('#deal_payment_method_id_1').prop('checked', true);
		}
	}
	if (countMethods('.deal_payment') == 1) {
		$('.deal_payment').prop('checked', true);
	}
}

function checkDelivery() {
	var any_checked = false;
	$('.deal_payment_quick').each(function () {
		if ($(this).prop('checked')) {
			any_checked = true;
		}
	});
	$('.deal_payment').each(function () {
		if ($(this).prop('checked')) {
			any_checked = true;
		}
	});
	if (!($('#deal_payment_method_id_1').prop('checked')) && any_checked) {
		addInactiveDelivery();
	} else {
		removeInactiveDelivery();
	}
}

function checkPaypal() {
	if ($('#deal_exchange_method_id_1').prop('checked')) {
		addInactivePayment();
	} else {
		removeInactivePayment();
	}
}

function updateDeals(location, form, completion) {
  formData = {}
	$(form).find(':input').each(function () {
		if ($(this).attr('type') != "radio" || $(this).prop("checked")) {
			formData[$(this).attr('name')] = $(this).val();
		}
	});
	$.ajax({
		type : "PATCH", // GET in place of POST
		url : location,
		data : formData,
		success : function (result) {
			completion();
		},
		error : function (e) {}
	});
}

function toggleVisible(section)
{
  if($('.inner_' + section + '_selection').children().length && !$('.complaint_selection').is(":visible"))
  {
    $('.inner_' + section + '_selection').parent().show();
  }
  else
  {
    $('.inner_' + section + '_selection').parent().hide();
  } 
}

function getDealId() {
  var str = window.location.href;
  var beginIndex = str.indexOf("deals/");
  var id = str.substring(beginIndex + 6);
  
  return id;
}

function refreshAll(completion) {
	var id = getDealId();
	$('.method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_method_selection", function () {});
	$('.exchange_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_exchange_method_selection", function () {
    toggleVisible('exchange_method');
  });
	$('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function () {});
	$('.payment_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_payment_method_selection", function () {});
	$('.completed_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_completed_selection", function () {
    toggleVisible('completed');  
  });
	$('.guide_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .guide_selection", function () {});
	$('.instructions').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_instructions", function () {
		completion();
	});
}

function refreshDeals() {
	var id = getDealId();
	var updated_at = parseInt($('#updated_at').val());
	$.ajax({
		type : "GET", // GET in place of POST
		url : window.location.protocol + "//" + window.location.host + "/deals/" + id.toString() + "/updated_at",
		success : function (result) {
			if (result > updated_at) {
				refreshAll(function(){});
			}
		}
	});
}

function getPostLoc() {
	var id = getDealId();
	var postLoc = '/deals/' + id.toString();
	return postLoc;
}

$(document).ready(function() {
	if ($('#on_the_deals_page').length > 0 && parseInt($('#on_the_deals_page').val()) == 1) //on deals
	{
		// refresh deals panel on an interval
		window.dealsInterval = setInterval(refreshDeals, 3000);
	} else {
		// clear deals interval
		clearInterval(window.dealsInterval);
	}

	$('.method_selection').show();
  $('.instructions').show();

  toggleVisible('completed');
  toggleVisible('exchange_method');

  $(document).on('click', '#file_complaint', function() {
    $('.instructions').hide();
    $('.selection').hide();
    $('.complaint_selection').show();
  });

  $(document).on('click', '#cancel_complaint', function() {
    $('.selection').show();
    $('.instructions').show();
    $('.complaint_selection').hide();
    toggleVisible('completed');
    toggleVisible('exchange_method');
  });
  
	$(document).on('click', '.not_ready', function (e) {
		e.preventDefault();
	});

	$(document).on('click', '.inactive_form_element', function (e) {
		e.preventDefault();
	});

	$(document).on('click', '.methods :input', function () {
		if (!($(this).hasClass("inactive_form_element"))) //don't execute graying out if the clicked is grayed out
		{
			checkDelivery();
			checkPaypal();
		}
	});

	$(document).on('click', '.methods_form_button', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
		updateDeals(postLoc, $(this).parent(), function () {
			refreshAll(function () {
				$('.instructions').append("<h3 class='methods_submission'>Congrats! You've successfully updated the methods of transaction.</h3>");
				validDelivery();
			});
		});
	});

	$(document).on('submit', '.price_submission', function (e) {
		e.preventDefault();
		if (parseFloat($('#price_proposal').val()) < parseFloat($('#minimum_price').val())) {
			$('#price_proposal').addClass('price_warning');
			$('.instructions_price_warning').remove();
			$('.instructions').append("<h3 class='instructions_price_warning'>Price offer too low.</h3");
		} else {
			$('.instructions_price_warning').remove();
			$('#price_proposal').removeClass('price_warning');
			var postLoc = getPostLoc();
			updateDeals(postLoc, $(this), function () {
				$('.selling_method_selection').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .inner_selling_method_selection", function () {});
			});
		}
	});

	$(document).on('click', '.deals_form_button', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
		updateDeals(postLoc, $(this).parent('form'), function () {
			refreshAll(function() {});
		});
	});

	$(document).on('click', '.deals_form_button_accept_price', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
		updateDeals(postLoc, $(this).parent('h3').parent('form'), function () {
			refreshAll(function() {});
		});
	});

	$(document).on('click', '.deals_form_button_in_header', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
		updateDeals(postLoc, $(this).parent('form'), function () {
			refreshAll(function(){});
		});
	});

	$(document).on('click', '.file_complaint_button', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
    updateDeals(postLoc, $(this).parent('form'), function () {
			var id = getDealId();
      $('.deals_form').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function () {});
		});
	});

	$(document).on('click', '.remove_complaint_button', function (e) {
		e.preventDefault();
		var postLoc = getPostLoc();
		updateDeals(postLoc, $(this).parent('form'), function () {
			var id = getDealId();
      $('.deals_form').load(window.location.protocol + "//" + window.location.host + '/deals/' + id.toString() + " .large_deals_form", function () {
        toggleVisible('completed');
        toggleVisible('exchange_method');
      });
		});

	});

	$(document).on('click', '.dropoff_location', function (e) {
		e.preventDefault();
		if (isValidAddress($('#deal_dropoff').val())) {
			var postLoc = getPostLoc();
			updateDeals(postLoc, $(this).parent('h3').parent('form'), function () {
				$('.valid_address').remove();
			});
		} else {
			$('.instructions').append("<h3 class='valid_address'>Please enter a valid street address.</h3>");
		}

	});

	// if on deals page

	if ($('#on_the_deals_page').length > 0) {
		validDelivery();
		checkDelivery();
		checkPaypal();
		defaultSelected();
	}
});
