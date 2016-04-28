function getToggleOptions(category_id)
{
    $.ajax({
	type: "GET",// GET in place of POST
	contentType: "application/json; charset=utf-8",
	url: "http://" + window.location.host + "/api/getToggleOptions?id=" + category_id.toString(),
	data: {},
	dataType: "json",
	success: function (result) {
	    $('.toggle_option_option').remove();
	    $('.submit_toggles').remove();
	    $('.toggle_option_select').remove();
	    for(var i = 0; i < result.length; i++)
	    {
		addToggle(result[i]);
				    
	    }
	    $('.toggle_br').remove();
	    $('#toggle_options_form').append("<br class='toggle_br'><input type='submit' name='commit' value='Submit Toggle Options' class='pure-button pure-button-primary submit_product submit_toggles'>");
	},
	error: function (e){
	}
    });
}

function addToggle(toggle_option)
{
    var id = toggle_option["id"];
    var select_id = "toggle_options_" + id + "_name";
    var select_access = "#" + select_id;
    $(select_access).remove();
    var name = toggle_option["name"];
    $('#toggle_options_form').append("<label for='toggle_options_" + id.toString() + "_name' class='toggle_option_option toggle_option_select'>" + name + "</label>");
    $('#toggle_options_form').append("<select name='toggle_options[" + id + "][name]' id='" + select_id +  "' class='toggle_option_select'></select>");
    var attr = toggle_option["attribute_options"];
    var select_access = "#" + select_id;
    for (var j = 0; j < attr.length; j++)
    {
	$(select_access).append("<option value='" + attr[j][0] + "'>" + attr[j][1] + "</option>");
    }
}

function mainDetails()
{
    var title = $('#product_title').val().length > 0;
    var price = $('#product_price').val() > 0;
    var description = $('#product_description').val().length > 0;
    if (!($('#product_address').length > 0))
    {
	var address = true;
    }
    else
    {
	var address = $('#product_address').val().length > 0;
    }
    return (title && price && description && address);
}

function toggleOptions()
{
    return true;
}

function sellingMethods()
{
    var thing = false;
    $('.selling_method').each(function(data, index) {

	if ($(this).prop("checked"))
	{
	    thing = true;
	}
    });
    return thing;    
}

function exchangeMethods()
{
    var thing = false;
    $('.exchange_method').each(function(data, index) {

	if ($(this).prop("checked"))
	{
	    thing = true;
	}
    });
    return thing;
}

function paymentMethods()
{
    var thing = false;
    $('.payment_method').each(function(data, index) {

	if ($(this).prop("checked"))
	{
	    thing = true;
	}
    });
    return thing;
}

function evaluateMain()
{
    if(mainDetails())
    {
	$('#main_form_button').removeClass('incomplete').addClass('complete');
    }
    else
    {
	$('#main_form_button').addClass('incomplete').removeClass('complete');
    }
}

function evaluateSelling()
{
    if (sellingMethods())
    {
	$('#selling_methods_button').removeClass('incomplete').addClass('complete');
    }
    else
    {
	$('#selling_methods_button').removeClass('complete').addClass('incomplete');
    }
}

function evaluateExchange()
{
    if (exchangeMethods())
    {
	$('#exchange_methods_button').removeClass('incomplete').addClass('complete');
    }
    else
    {
	$('#exchange_methods_button').removeClass('complete').addClass('incomplete');
    }
}

function evaluatePayment()
{
    if (paymentMethods())
    {
	$('#payment_methods_button').removeClass('incomplete').addClass('complete');
    }
    else
    {
	$('#payment_methods_button').removeClass('complete').addClass('incomplete');
    }
}
function evaluateAll()
{
    evaluateMain();
    evaluateSelling();
    evaluateExchange();
    evaluatePayment();
    $('#toggle_options_button').addClass('complete');
}

$(document).ready(function() {
    $('.cropped_show').click(function() {
	console.log('hi');
	smallImage = $(this).attr('src');
	smallLink = $(this).next().val();
	$('.cropped_show').removeClass('pic_active');
	$(this).addClass('pic_active');


	$('.product_image').attr('src', smallImage.replace('thumbnail', 'medium'));
	$('#magnifier').next().attr('href', smallLink);

    });

    $('.category_name').change(function() {
	$('.category_name').val($(this).val());
	getToggleOptions(parseInt($(this).val()));
	
    });
    
    if ($('#product_title').length > 0)
    {
	evaluateAll();
    }
    
    $('.main_field').keyup(function() {
	evaluateMain();
    });

    $('.selling_method').click(function() {
	evaluateSelling();
    });

    $('#selling_methods_button').click(function() {
	evaluateSelling();
    });

    $('.exchange_method').click(function() {
	evaluateExchange();
    });

    $('#exchange_methods_button').click(function() {
	evaluateExchange();
    });

    $('.payment_method').click(function() {
	evaluatePayment();
    });

    $('#payment_methods_button').click(function() {
	evaluatePayment();
    });

    $('.submit_product').click(function(e) {
	var forms = mainDetails() && paymentMethods() && sellingMethods() && exchangeMethods();
	if (!forms)
	{
	    e.preventDefault();
	    var msg = "You are missing important information: ";
	    if (!mainDetails())
	    {
		msg += "main product information";
	    }
	    if (!sellingMethods())
	    {
		msg += ", selling methods";
	    }
	    if (!exchangeMethods())
	    {
		msg += ", exchange methods";
	    }
	    if (!paymentMethods())
	    {
		msg += ", payment methods";
	    }
	    $('.alert').remove();
	    $('.content').prepend("<div class='alert alert-warning'>" + msg + "</div>");
	}
    });

$('#magnifier').loupe({
  width: 600, // width of magnifier
  height: 600, // height of magnifier
  loupe: 'loupe' // css class for magnifier
});

$('.magnifier').loupe({
  width: 300, // width of magnifier
  height: 300, // height of magnifier
  loupe: 'loupe' // css class for magnifier
});
    $('#dropper').hide();
    $('#toggle_options_form').hide();
    $('#selling_methods_form').hide();
    $('#exchange_methods_form').hide();
    $('#payment_methods_form').hide();
    $('#toggle_options_button').click(function() {
	$('fieldset').hide();
	$('#dropper').hide();
	$('#toggle_options_form').show();
    });

    $('#selling_methods_button').click(function() {
	$('fieldset').hide();
	$('#dropper').hide();
	$('#selling_methods_form').show();
	
    });
    $('#exchange_methods_button').click(function() {
	$('fieldset').hide();
	$('#dropper').hide();
	$('#exchange_methods_form').show();
    });
    $('#payment_methods_button').click(function() {
	$('fieldset').hide();
	$('#dropper').hide()
	$('#payment_methods_form').show();
    });
    $('#main_form_button').click(function() {
	$('fieldset').hide();
	$('#dropper').hide();
	$('#product_form').show();
    });
    $('#dropper_button').click(function() {
	$('fieldset').hide();
	$('#dropper').show();
    });
});


