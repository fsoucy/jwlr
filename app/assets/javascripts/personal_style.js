$(document).ready(function() {
    //
    $('.search_string').focusin(function() {

	if (('#sug_list').val().length == 0)
	{
	}
	else
	{
	    $('#sug_list').css('display', 'block');
	    updateSearch();
	}

    });

    $('.search_string').focusout(function() {

	$('#sug_list').css('display', 'none');
    });

    $('.search_string').keydown(function(event) {
	
	var key = event.which;
	if (key == 38 || key == 40)
	{
	    event.preventDefault();
	    if (key == 40)
	    {
		var done = false;
		if ($('#sug_list > .active').is('#sug_list > :last-child') && !done)
		{
		    $('#sug_list > :last-child').removeClass('active');
		    $('#sug_list > :first-child').addClass('active');
		    done = true;
		}
		if (!done)
		{
		    $('#sug_list > .active').next().addClass('next');
		    $('#sug_list > .active').removeClass('active');
		    $('#sug_list > .next').addClass('active').removeClass('next');  
		}
	    }
	    if (key == 38)
	    {
		var done = false;
		if ($('#sug_list > .active').is('#sug_list > :first-child') && !done)
		{
		    $('#sug_list > :first-child').removeClass('active');
		    $('#sug_list > :last-child').addClass('active');
		    done = true;
		}
		if (!done)
		{
		    $('#sug_list > .active').prev().addClass('next');
		    $('#sug_list > .active').removeClass('active');
		    $('#sug_list > .next').addClass('active').removeClass('next');
		}
	    }
	}
	else
	{
	    updateSearch();
	}
	
    });

    function updateSearch()
    {
	$.ajax({
	    type: "GET",// GET in place of POST
	    contentType: "application/json; charset=utf-8",
	    url: "http://162.213.199.215:3002/search_suggestions",
	    data: {search_string: $('.search_string').val()},
	    dataType: "json",
	    success: function (result) {
		//do somthing here
		var str = "";
		res = "" + result;
		var parts = res.split(',');
		for (thing in parts)
		{
		    if (str.length == 0)
		    {
			var add = "<li class='active'>";
		    }
		    else
		    {
			var add = "<li>"
		    }
		    str += add + parts[thing] + '</li>';
		}
		$('#sug_list').html(str);
		if (res.length == 0)
		{
		    $('#sug_list').css('display', 'none');
		}
		else
		{
		    $('#sug_list').css('display', 'block');
		}
	    },
	    error: function (e){
	    }
	});
    }

    //home header
    $('.dropdown_header').mouseenter(function() {
	$('.dropdown_menu_header').css('display', 'block');

    });

    $('.dropdown_header').mouseleave(function() {
	$('.dropdown_menu_header').css('display', 'none');
    });

    //storefront
    $('.quick_view').hide();

    $('.quick_view').click(function() {
	var $toPut = "<div class='modal'><p>What the</p></div>";
	$('body').append($toPut);
	
	//$('body').append(toPut);
    });
    
    $('.store_inactive').hide();
    $('.store_active').show();

    $('.image_container').mouseenter(function() {
	$(this).children('.quick_view').slideToggle("slow");
    });

    $('.image_container').mouseleave(function() {
	$(this).children('.quick_view').slideToggle("slow");
    });
    
    $('.gallery_button').click(function() {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_gallery_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });

    $('.blog_button').click(function() {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_blog_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });

    $('.contact_button').click(function() {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_contact_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });

    $('.about_button').click(function() {
	$('.store_active').removeClass('store_active').addClass('store_inactive').fadeOut();
	$('.store_about_within').removeClass('store_inactive').addClass('store_active').delay(260).fadeIn();
    });
	//end storefront
	
    $('.gold_coins_div').hide();
    $('.jewelry_div').hide();
    $('.gold_bricks_div').hide();
    $('.precious_stones_div').hide();
    $('.big_product_image').hide();
    
    $('.all').click(function() {
	$(this).removeClass('inactive').addClass('active');
	$('.gold_coins').removeClass('active').addClass('inactive');
	$('.jewelry').removeClass('active').addClass('inactive');
	$('.gold_bricks').removeClass('active').addClass('inactive');
	$('.precious_stones').removeClass('active').addClass('inactive');
	$('.jewelry_div').hide();
	$('.gold_coins_div').hide();
	$('.gold_bricks_div').hide();
	$('.precious_stones_div').hide();
	$('.all_div').show();
    });
    
    $('.gold_coins').click(function() {
	$(this).removeClass('inactive').addClass('active');
        $('.jewelry').removeClass('active').addClass('inactive');
        $('.all').removeClass('active').addClass('inactive');
	$('.gold_bricks').removeClass('active').addClass('inactive');
	$('.precious_stones').removeClass('active').addClass('inactive');
        $('.all_div').hide();
        $('.jewelry_div').hide();
	$('.gold_bricks_div').hide();
	$('.precious_stones_div').hide();
        $('.gold_coins_div').show();
    });
    
    
    $('.jewelry').click(function() {
        $(this).removeClass('inactive').addClass('active');
        $('.gold_coins').removeClass('active').addClass('inactive');
        $('.all').removeClass('active').addClass('inactive');
	$('.gold_bricks').removeClass('active').addClass('inactive');
        $('.precious_stones').removeClass('active').addClass('inactive');
	$('.gold_bricks_div').hide();
        $('.precious_stones_div').hide();
        $('.all_div').hide();
        $('.gold_coins_div').hide();
        $('.jewelry_div').show();
    });
    
    $('.gold_bricks').click(function() {
        $(this).removeClass('inactive').addClass('active');
        $('.gold_coins').removeClass('active').addClass('inactive');
        $('.all').removeClass('active').addClass('inactive');
	$('.jewelry').removeClass('active').addClass('inactive');
        $('.precious_stones').removeClass('active').addClass('inactive');
	$('.jewelry_div').hide();
        $('.precious_stones_div').hide();
        $('.all_div').hide();
        $('.gold_coins_div').hide();
        $('.gold_bricks_div').show();
    });
    
    $('.precious_stones').click(function() {
        $(this).removeClass('inactive').addClass('active');
        $('.gold_coins').removeClass('active').addClass('inactive');
        $('.all').removeClass('active').addClass('inactive');
	$('.gold_bricks').removeClass('active').addClass('inactive');
        $('.jewelry').removeClass('active').addClass('inactive');
	$('.gold_bricks_div').hide();
        $('.jewelry_div').hide();
        $('.all_div').hide();
        $('.gold_coins_div').hide();
        $('.precious_stones_div').show();
    });
    
    $('.product_image').mouseover(function() {
	$(this).hide();
	$('.big_product_image').show();
    });
    
    $('.big_product_image').mouseout(function() {
	$(this).hide();
	$('.product_image').show();
    });
    
    
    
});
