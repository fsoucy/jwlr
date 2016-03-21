$(document).ready(function() {
    $('#price_warning').hide()
    $('.propose_price').click(function(e) {
	if (parseFloat($('#price_proposal').val()) < parseFloat($('#minimum_price').val()))
	{
	    e.preventDefault();
	    $('#price_proposal').css('color', 'red');
	    $('#price_proposal').css('border-color', 'red');
	    $('#price_warning').show();
	}
    });
   
});
