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

    $('.main_field').keyup(function() {
	if(mainDetails())
	{
	    $('#main_form_button').removeClass('incomplete').addClass('complete');
	}
	else
	{
	    $('#main_form_button').addClass('incomplete').removeClass('complete');
	}
    });

    $('.selling_method').click(function() {
	if (sellingMethods())
	{
	    $('#selling_methods_button').removeClass('incomplete').addClass('complete');
	}
	else
	{
	    $('#selling_methods_button').removeClass('complete').addClass('incomplete');
	}
    });

    $('.exchange_method').click(function() {
	if (exchangeMethods())
	{
	    $('#exchange_methods_button').removeClass('incomplete').addClass('complete');
	}
	else
	{
	    $('#exchange_methods_button').removeClass('complete').addClass('incomplete');
	}
    });

    $('.payment_method').click(function() {
	if (paymentMethods())
	{
	    $('#payment_methods_button').removeClass('incomplete').addClass('complete');
	}
	else
	{
	    $('#payment_methods_button').removeClass('complete').addClass('incomplete');
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

    $('#toggle_options_form').hide();
    $('#selling_methods_form').hide();
    $('#exchange_methods_form').hide();
    $('#payment_methods_form').hide();
    $('#toggle_options_button').click(function() {
	$('fieldset').hide();
	$('#toggle_options_form').show();
    });

    $('#selling_methods_button').click(function() {
	$('fieldset').hide();
	$('#selling_methods_form').show();
	
    });
    $('#exchange_methods_button').click(function() {
	$('fieldset').hide();
	$('#exchange_methods_form').show();
    });
    $('#payment_methods_button').click(function() {
	$('fieldset').hide();
	$('#payment_methods_form').show();
    });
    $('#main_form_button').click(function() {
	$('fieldset').hide();
	$('#product_form').show();
    });
});
