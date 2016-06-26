$(document).ready(function () {

    var url = window.location.href;
    $('.store_within').addClass('store_inactive');
    if (url.includes("#about"))
    {
	$('.store_about_within').removeClass("store_inactive").addClass("store_active");
    }
    else if (url.includes("#contact"))
    {
	$('.store_contact_within').removeClass("store_inactive").addClass("store_active");
    }
    else if (url.includes("#blog"))
    {
	$('.store_blog_within').removeClass("store_inactive").addClass("store_active");
    }
    else
    {
	$('.store_gallery_within').removeClass("store_inactive").addClass("store_active");
    }

    
    
    $('.store_inactive').hide();
    $('.store_active').show();
    
    $('.image_container').mouseenter(function () {
	$(this).children('.quick_view').slideToggle("slow");
    });
    
    $('.image_container').mouseleave(function () {
	$(this).children('.quick_view').slideToggle("slow");
    });
    
    $('.gallery_butt').click(function () {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_gallery_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });
    
    $('.blog_butt').click(function () {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_blog_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });
    
    $('.contact_butt').click(function () {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_contact_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });
    
    $('.about_butt').click(function () {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_about_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });

    $(document).on('input', '.start_hour', function() {
	var value = $(this).val();
	$('.start_hour').each(function(thing1, thing2) {
	    if (parseInt($(this).val()) == -1)
	    {
		$(this).val(value);
	    }
	});
    });

    $(document).on('input', '.start_minute', function() {
	var value = $(this).val();
	$('.start_minute').each(function(thing1, thing2) {
	    if (parseInt($(this).val()) == -1)
	    {
		$(this).val(value);
	    }
	});
    });

    $(document).on('input', '.end_hour', function() {
	var value = $(this).val();
	$('.end_hour').each(function(thing1, thing2) {
	    if (parseInt($(this).val()) == -1)
	    {
		$(this).val(value);
	    }
	});
    });

    $(document).on('input', '.end_minute', function() {
	var value = $(this).val();	
	$('.end_minute').each(function(thing1, thing2) {
	    if (parseInt( $(this).val()) == -1)
	    {
		$(this).val(value);
	    }
	});
    });
    
});
