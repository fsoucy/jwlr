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
