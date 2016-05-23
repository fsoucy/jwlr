
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
	$('.guide_selection').show();
    });

    
    $(document).on('click', '.selling_button', function() {
	$('.selection').hide();
	$('.selling_method_selection').show();
    });

    $(document).on('click', '.methods_button', function() {
	$('.selection').hide();
	$('.method_selection').show();
    });

    $(document).on('click', '.exchange_button', function() {
	$('.selection').hide();
	$('.exchange_method_selection').show();
    });

    $(document).on('click', '.payment_button', function() {
	$('.selection').hide();
	$('.payment_method_selection').show();
    });

    $(document).on('click', '.completed_button', function() {
	$('.selection').hide();
	$('.completed_selection').show();
    });
    
    $(document).on('click', '.deals_form_button', function(e) {
	e.preventDefault();
	
	var str = window.location.href;
	var beginIndex = str.indexOf("deals/");
	var id = str.substring(beginIndex + 6);
	debugger;
	var postLoc = '/deals/' + id.toString();
	$.post('/deals/23', $(this).parent('form').serialize());
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

    redirectToPage();
    

});
