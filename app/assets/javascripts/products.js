$(document).on('click', '.deal_selling_product', function() {
  if($('#deal_selling_method_id_3').prop('checked'))
  {
    $('.product_show_initiate_deal').val('Make offer');
  }
  else
  {
    $('.product_show_initiate_deal').val('Buy this product');
  }
});

$(document).ready(function () {
	if ($(".shares").length) {
		$.getScript("//platform.twitter.com/widgets.js");
		$.getScript("//assets.pinterest.com/js/pinit_main.js");
	}
});

function productFromGallery() {
	var str = window.location.href;
	var index = str.indexOf("?");
	if (index != -1) {
		var idLoc = index + 12;
		var id = str.substring(idLoc);
		var link = "/products/" + id + "/add_pictures";
		if ($('#users_picture_upload').length > 0) {
			console.log(id.toString());
			$('#users_picture_upload').attr("href", link);
		}
	}
}

function getToggleOptions(category_id) {
	$.ajax({
		type : "GET", // GET in place of POST
		contentType : "application/json; charset=utf-8",
		url : window.location.protocol + "//" + window.location.host + "/api/getToggleOptions?id=" + category_id.toString(),
		data : {},
		dataType : "json",
		success : function (result) {
			$('.toggle_option_option').remove();
			$('.save_toggles').remove();
			$('.submit_toggles').remove();
			$('.toggle_option_select').remove();
			for (var i = 0; i < result.length; i++) {
				addToggle(result[i]);

			}
			$('.product_previous_toggle').remove();
			$('.product_next_toggle').remove();
			$('.toggle_br').remove();
			$('#toggle_options_form').append("<button class='pure-button pure-button-primary prod_cont product_previous_toggle' type='button'>Previous</button>\n");
			$('#toggle_options_form').append("<button class='pure-button pure-button-primary prod_cont product_next_toggle' type='button'>Next</button>");
			$('#toggle_options_form').append("<br class='toggle_br'><input type='submit' name='commit' value='Save product' class='pure-button pure-button-primary prod_cont save save_toggles'>\n");
			$('#toggle_options_form').append("<input type='submit' name='commit' value='Submit product' class='pure-button pure-button-primary prod_cont submit_product submit_toggles'>");
			evaluateSubmit();
		},
		error : function (e) {}
	});
}

function reloadProductType(category_id, change, cat_id) {
	$.ajax({
		type : "GET", // GET in place of POST
		contentType : "application/json; charset=utf-8",
		url : window.location.protocol + "//" + window.location.host + "/api/getChildrenCategories?id=" + category_id.toString(),
		data : {},
		dataType : "json",
		success : function (result) {
			$('.category_name option').remove();
			for (var i = 0; i < result.length; i++) {
				var thing = result[i];
				console.log(thing["children"])
				if (parseInt(thing["children"]) == 0) {
					console.log('hi');
					var thing_id = "child_" + thing["id"];
					var html = "<option id='" + thing_id + "'" + "value='" + thing["id"] + "'>" + thing["name"] + "</option>";
					$('.category_name').append(html);
				} else {
					//has children
				}
			}
			if (change) {
				$('.category_name').val(cat_id);
			}
		},
		error : function (e) {}
	});
}

function getCategoryDropdown() {
	if ($('.parent_category_name').length > 0) {
		reloadProductType(parseInt($('.parent_category_name').val()), false, 0);
	}
}

function loadCategories() {
	if ($('#edit').length > 0 && $('#edit').val() == "true") {
		var parent_id = $('#initial_parent_category').val().toString();
		var cat_id = $('#initial_category').val().toString();
		$('.parent_category_name').val(parent_id);
		reloadProductType(parent_id, true, cat_id);
	}
}

function addToggle(toggle_option) {
	var id = toggle_option["id"];
	var select_id = "toggle_options_" + id + "_name";
	var select_access = "#" + select_id;
	$(select_access).remove();
	var name = toggle_option["name"];
	$('#toggle_options_form').append("<label for='toggle_options_" + id.toString() + "_name' class='toggle_option_option toggle_option_select'>" + name + "</label>");
	$('#toggle_options_form').append("<select name='toggle_options[" + id + "][name]' id='" + select_id + "' class='toggle_option_select'></select>");
	var attr = toggle_option["attribute_options"];
	var select_access = "#" + select_id;
	for (var j = 0; j < attr.length; j++) {
		$(select_access).append("<option value='" + attr[j][0] + "'>" + attr[j][1] + "</option>");
	}
}

function mainDetails() {
	var title = $('#product_title').val().length > 0;
	var price = $('#product_price').val() > 0;
	var description = $('#product_description').val().length > 0;
	if (!($('#product_address').length > 0)) {
		var address = true;
	} else {
		var address = $('#product_address').val().length > 0;
	}
	return (title && price && description && address);
}

function toggleOptions() {
	return true;
}

function productPicture() {
	return $('.dz-success').length > 0 || parseInt($('#has_picture').val()) > 0;
}

function deliveryAndPaypal() {
	var correct = true;
	if ($('#exchange_method_links_1_id').prop('checked') && !($('#payment_method_links_1_id').prop('checked'))) {
		correct = false;
	}
	return correct;
}

function showDeliveryCost() {
	if ($('#exchange_method_links_1_id').prop('checked')) {
		$('.delivery_cost').show();
	} else {
		$('.delivery_cost').hide();
	}
}

function evaluatePicture() {
	if (productPicture()) {
		$('#dropper_button').removeClass('incomplete').addClass('complete');
	} else {
		$('#dropper_button').removeClass('complete').addClass('incomplete');
	}
}

function sellingMethods() {
	var thing = false;
	$('.selling_method').each(function (data, index) {

		if ($(this).prop("checked")) {
			thing = true;
		}
	});
	return thing;
}

function exchangeMethods() {
	var thing = false;
	$('.exchange_method').each(function (data, index) {

		if ($(this).prop("checked")) {
			thing = true;
		}
	});
	if ($('#exchange_method_links_1_id').prop('checked') && $('#delivery_cost').val().length == 0) {
		return false;
	} else {
		return thing;
	}
}

function paymentMethods() {
	var thing = false;
	$('.payment_method').each(function (data, index) {

		if ($(this).prop("checked")) {
			thing = true;
		}
	});
	return thing;
}

function ready() {
	return mainDetails() && sellingMethods() && exchangeMethods() && paymentMethods() && productPicture() && deliveryAndPaypal();
}

function readyToSave() {
	if (ready()) {
		return true;
	} else {
		return mainDetails();
	}
}

function evaluateSubmit() {
	evaluateSave();
	if (ready()) {
		$('.submit_product').removeClass('not_ready');
		$('.submit_product_picture').removeClass('not_ready');
	} else {
		$('.submit_product').addClass('not_ready');
		$('.submit_product_picture').addClass('not_ready');
	}
}

function evaluateMain() {
	if (mainDetails()) {
		$('#main_form_button').removeClass('incomplete').addClass('complete');
		$('.product_next_main').removeClass('not_ready');
	} else {
		$('#main_form_button').addClass('incomplete').removeClass('complete');
		$('.product_next_main').addClass('not_ready');
	}
	evaluateSubmit();
}

function evaluateSelling() {
	if (sellingMethods()) {
		$('#selling_methods_button').removeClass('incomplete').addClass('complete');
		$('.product_next_selling').removeClass('not_ready');
	} else {
		$('#selling_methods_button').removeClass('complete').addClass('incomplete');
		$('.product_next_selling').addClass('not_ready');
	}
	evaluateSubmit();
}

function evaluateDelivery() {
	if (!deliveryAndPaypal()) {
		$('#deliveryAndPaypal').remove();
		$('.content').prepend('<div class="alert alert-warning" id="deliveryAndPaypal"><h4>Delivery must be accompanied by Paypal. Please, either remove delivery or add Paypal as a payment method.</h4></div>');
	} else {
		$('#deliveryAndPaypal').remove();
	}
}

function evaluateExchange() {
	if (exchangeMethods()) {
		$('#exchange_methods_button').removeClass('incomplete').addClass('complete');
		$('.product_next_exchange').removeClass('not_ready');
	} else {
		$('#exchange_methods_button').removeClass('complete').addClass('incomplete');
		$('.product_next_exchange').addClass('not_ready');
	}
	evaluateDelivery();
	evaluateSubmit();
}

function evaluatePayment() {
	if (paymentMethods()) {
		$('#payment_methods_button').removeClass('incomplete').addClass('complete');
		$('.product_next_payment').removeClass('not_ready');
	} else {
		$('#payment_methods_button').removeClass('complete').addClass('incomplete');
		$('.product_next_payment').addClass('not_ready');
	}
	evaluateDelivery();
	evaluateSubmit();
}
function evaluateAll() {
	evaluateMain();
	evaluateSelling();
	evaluateExchange();
	evaluatePayment();
	evaluatePicture();
	evaluateSubmit();
	$('#toggle_options_button').addClass('complete');
}

function evaluateDealSubmitQuick() {
	if ((evaluateDealSellingQuick() && evaluateDealExchangeQuick() && evaluateDealPaymentQuick())) {
		$('.in_quick_buy').removeClass("not_ready");
	} else {
		$('.in_quick_buy').addClass("not_ready");
	}
}

function evaluateDealSellingQuick() {
	return true;
}

function evaluateDealExchangeQuick() {
	var filled = false;
	$('.deal_exchange_quick').each(function () {
		if ($(this).prop('checked')) {
			filled = true;
		}
	});
	return filled;
}

function evaluateDealPaymentQuick() {
	var filled = false;
	$('.deal_payment_quick').each(function () {
		if ($(this).prop('checked')) {
			filled = true;
		}
	});
	return filled;
}

function evaluateDealSubmit() {
	if (evaluateDealSelling() && evaluateDealExchange() && evaluateDealPayment()) {
		$('.product_show_initiate_deal').removeClass('not_ready');
	} else {
		$('.product_show_initiate_deal').addClass('not_ready');
	}
}

function evaluateDealSelling() {
	var filled = false;
	$('.deal_selling').each(function () {
		if ($(this).prop('checked')) {
			filled = true;
		}
	});
	if ($('#deal_selling_method_id_3').prop('checked') && $('#deal_user_proposed_price').val().length == 0) {
		filled = false;
	}
	return filled;
}

function evaluateDealExchange() {
	var filled = false;
	$('.deal_exchange').each(function () {
		if ($(this).prop('checked')) {
			filled = true;
		}
	});
	return filled;
}

function evaluateDealPayment() {
	var filled = false;
	$('.deal_payment').each(function () {
		if ($(this).prop('checked')) {
			filled = true;
		}
	});
	return filled;
}

function addInactivePaymentQuick() {
	$('.deal_payment_quick').addClass("inactive_form_element");
	$('.deal_payment_label_quick').addClass("inactive_form_element");
	$('#payment_method_1').removeClass("inactive_form_element");
	$('#payment_method_1').prev().removeClass("inactive_form_element");
}

function removeInactivePaymentQuick() {
	$('.deal_payment_quick').removeClass("inactive_form_element");
	$('.deal_payment_label_quick').removeClass("inactive_form_element");
}

function addInactiveDeliveryQuick() {
	$('#exchange_method_1').addClass("inactive_form_element");
	$('#exchange_method_1').prev().addClass("inactive_form_element");
}

function removeInactiveDeliveryQuick() {
	$('#exchange_method_1').removeClass("inactive_form_element");
	$('#exchange_method_1').prev().removeClass("inactive_form_element");
}

function defaultSelectedQuick() {
	if (countMethods('.deal_selling_quick') == 1) {
		$('.deal_selling_quick').prop('checked', true);
	}
	if (countMethods('.deal_exchange_quick') == 1) {
		$('.deal_exchange_quick').prop('checked', true);
	  if ($('#exchange_method_1').length > 0 && $('#exchange_method_1').prop('checked'))
    {
      $('#payment_method_1').prop('checked', true);
    }
  }
	if (countMethods('.deal_payment_quick') == 1) {
		$('.deal_payment_quick').prop('checked', true);
	}
}

function checkPaypalQuick() {
	if ($('#exchange_method_1').prop('checked')) {
		addInactivePaymentQuick();
	} else {
		removeInactivePaymentQuick();
	}
}

function checkDeliveryQuick() {
	console.log('triggered');
	var any_checked = false;
	$('.deal_payment_quick').each(function () {
		if ($(this).prop('checked')) {
			any_checked = true;
		}
	});
	if (!($('#payment_method_1').prop('checked')) && any_checked) {
		addInactiveDeliveryQuick();
	} else {
		removeInactiveDeliveryQuick();
	}
}

function evaluateSave() {
	console.log('happened');
	if (ready() || parseInt($('#activated').val()) > 0) {
		$('.save').hide();
	} else {
		$('.save').show();
	}
	if (readyToSave()) {
		$('.save').removeClass("not_ready");
	} else {
		$('.save').addClass("not_ready");
	}
}

function evaluateUponTransaction() {
	if ($("#payment_method_links_2_id").prop('checked')) {
		$('#upon_transaction').show();
	} else {
		$('#upon_transaction').hide();
	}
}

$(document).ready(function () {
	hs.graphicsDir = '/assets/hsgraphics/';

	productFromGallery();
	$('#product_redirect_pictures').val('0');
	$('.cropped_show').click(function () {
		var smallImage = $(this).attr('src');
		var smallLink = $(this).siblings('.pathway').val();
		var deleteLink = $(this).siblings('.delete_pathway').val();

		$(this).parent().siblings().children("img").removeClass('pic_active');
		$(this).addClass('pic_active');

		$(this).parent().siblings(".magnifier").children('.product_image').attr('src', smallImage.replace('thumbnail', 'large'));
		$(this).parent().siblings('.product_edit').attr('href', smallLink);
		$(this).parent().siblings(".product_delete").attr('href', deleteLink);
		var picLink = $(this).siblings('.mag_link').val();

		$(this).parent().siblings(".magnifier").attr('href', picLink);
		$(".loupe").remove();
		$(".magnifier").data("loupe", null);
		$(".magnifier").loupe({
			width : 300, // width of magnifier
			height : 300, // height of magnifier
			loupe : 'loupe' // css class for magnifier
		});
	});

	$('.category_name').change(function () {
		$('.category_name').val($(this).val());
		getToggleOptions(parseInt($(this).val()));

	});

	$('.submit_product_picture').click(function (e) {
		e.preventDefault();
		$('.submit_product').trigger('click');
	});

	$('.pan_img').click(function (e) {
		e.preventDefault();
		$('#has_picture').val('1');
		$('#product_redirect_pictures').val('1');
		evaluateSubmit();
		$('.submit_product').trigger('click');
	});

	$('.submit_prod_picture').click(function (e) {
		e.preventDefault();
		$('.submit_product').trigger('click');
	});

	if ($('#product_title').length > 0) {
		evaluateAll();
	}

	$('.main_field').keyup(function () {
		evaluateMain();
	});

	$('.selling_method').click(function () {
		evaluateSelling();
	});

	$('#selling_methods_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#selling_methods_form').show();
		evaluateSelling();
	});

	$('.exchange_method').click(function () {
		showDeliveryCost();
		evaluateExchange();
	});

	$('#exchange_methods_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#exchange_methods_form').show();
		evaluateExchange();
	});

	$('.payment_method').click(function () {
		evaluatePayment();
	});

	$('#payment_methods_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#payment_methods_form').show();
		evaluatePayment();
	});

	$('#main_form_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#product_form').show();
	});

	$('#toggle_options_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#toggle_options_form').show();
	});

	$('#dropper_button').click(function () {
		$('.log-in-form fieldset').hide();
		$('#dropper').show();
	});

	$(document).on('change', '.parent_category_name', function () {
		getCategoryDropdown();
	});

	$(document).on('click', '.deal_radio', function () {
		checkDelivery();
		checkPaypal();
		evaluateDealSubmit();
	});

	$(document).on('keyup', '#deal_user_proposed_price', function () {
		evaluateDealSubmit();
	});

	$(document).on('click', '.buy_now_radio', function () {
		checkDeliveryQuick();
		checkPaypalQuick();
		evaluateDealSubmitQuick();
	});

	$(document).on('keyup', '#delivery_cost', function () {
		evaluateExchange();
	});

	$(document).on('click', '.product_next_main', function () {
		if (mainDetails()) {
			$('#product_form').hide();
			$('#toggle_options_form').show();
		}
	});

	$(document).on('click', '.product_previous_toggle', function () {
		$('#toggle_options_form').hide();
		$('#product_form').show();
	});

	$(document).on('click', '.product_next_toggle', function () {
		if (toggleOptions()) {
			$('#toggle_options_form').hide();
			if (sellingMethods()) {
				if (exchangeMethods()) {
					if (paymentMethods()) {
						$('#dropper').show();
					} else {
						$('#payment_methods_form').show();
					}
				} else {
					$('#exchange_methods_form').show();
				}
			} else {
				$('#selling_methods_form').show();
			}
		}
	});

	$(document).on('click', '.product_previous_selling', function () {
		$('#selling_methods_form').hide();
		$('#toggle_options_form').show();
	});

	$(document).on('click', '.product_next_selling', function () {
		if (sellingMethods()) {
			$('#selling_methods_form').hide();
			if (exchangeMethods()) {
				if (paymentMethods()) {
					$('#dropper').show();
				} else {
					$('#payment_methods_form').show();
				}
			} else {
				$('#exchange_methods_form').show();
			}
		}
	});

	$(document).on('click', '.product_previous_exchange', function () {
		$('#exchange_methods_form').hide();
		$('#selling_methods_form').show();
	});

	$(document).on('click', '.product_next_exchange', function () {
		if (exchangeMethods()) {
			$('#exchange_methods_form').hide();
			if (paymentMethods()) {
				$('#dropper').show();
			} else {
				$('#payment_methods_form').show();
			}
		}
	});

	$(document).on('click', '.product_previous_payment', function () {
		$('#payment_methods_form').hide();
		$('#exchange_methods_form').show();
	});

	$(document).on('click', '.product_next_payment', function () {
		if (paymentMethods()) {
			$('#payment_methods_form').hide();
			$('#dropper').show();
		}
	});

	$(document).on('click', '.product_previous_picture', function () {
		$('#dropper').hide();
		$('#payment_methods_form').show();
	});

	$(document).on('click', '#payment_method_links_2_id', function () {
		evaluateUponTransaction();
	});

    $('.quick_buy_information').hide();
    $('.leave_quick_buy').hide();
	$(document).on('click', '.quick_buy', function (e) {
		if ($('.buy_now_radio').length > 0) {
			e.preventDefault();
			$('.quick_buy_information').show();
			$(this).removeClass("quick_buy");
			$('.deal_extended').hide();
		    $(this).addClass("in_quick_buy");
		    $('.leave_quick_buy').show();
		}
		evaluateDealSubmitQuick();
	});

	$(document).on('click', '.leave_quick_buy', function () {
	    $('.quick_buy_information').hide();
	    $('.leave_quick_buy').hide();
    $('.in_quick_buy').addClass("quick_buy").removeClass("in_quick_buy").removeClass("not_ready");
		$('.deal_extended').show();
		evaluateDealSubmitQuick();
	});

	$('.submit_product').click(function (e) {
		var forms = mainDetails() && paymentMethods() && sellingMethods() && exchangeMethods() && productPicture() && deliveryAndPaypal();
		if (!forms) {
			e.preventDefault();
			var msg = "You are missing important information: ";
			if (!mainDetails()) {
				msg += "<br>Main product information";
			}
			if (!sellingMethods()) {
				msg += "<br>Selling methods";
			}
			if (!exchangeMethods()) {
				msg += "<br>Exchange methods";
			}
			if (!paymentMethods()) {
				msg += "<br>Payment methods";
			}
			if (!productPicture()) {
				msg += "<br>Picture";
			}
			if (!deliveryAndPaypal()) {
				msg += "<br>Paypal must be a payment option if you're allowing delivery";
			}
			$('.alert').remove();
			$('.content').prepend("<div class='alert alert-warning'><h4>" + msg + "</h4></div>");
		}

	});

	$('.magnifier').loupe({
		width : 1500, // width of magnifier
		height : 1500, // height of magnifier
		loupe : 'loupe' // css class for magnifier
	});
	$('#dropper').hide();
	$('#toggle_options_form').hide();
	$('#selling_methods_form').hide();
	$('#exchange_methods_form').hide();
	$('#payment_methods_form').hide();

	showDeliveryCost();
	defaultSelected();
	defaultSelectedQuick();
	evaluateDealSubmit();
	evaluateDealSubmitQuick();
	getCategoryDropdown();
	evaluateUponTransaction();
	loadCategories();
	$('#toggle_options_button').click(function () {
		$('fieldset').hide();
		$('#dropper').hide();
		$('#toggle_options_form').show();
	});

	$('#selling_methods_button').click(function () {
		$('fieldset').hide();
		$('#dropper').hide();
		$('#selling_methods_form').show();

	});
	$('#exchange_methods_button').click(function () {
		$('fieldset').hide();
		$('#dropper').hide();
		$('#exchange_methods_form').show();
	});
	$('#payment_methods_button').click(function () {
		$('fieldset').hide();
		$('#dropper').hide()
		$('#payment_methods_form').show();
	});
	$('#main_form_button').click(function () {
		$('fieldset').hide();
		$('#dropper').hide();
		$('#product_form').show();
	});
	$('#dropper_button').click(function () {
		$('fieldset').hide();
		$('#dropper').show();
	});
});

$(document).on('click', '.loupe', function (event) {
	event.preventDefault();
	return hs.expand(this, {
		src : $(this).children("img").attr("src"),
		align : 'center'
	});
});

$(document).on('click', '.magnifier', function (event) {
	event.preventDefault();
	return hs.expand(this, {
		src : $(this).attr("src"),
		align : 'center'
	});
});
