$(document).ready(function() {
    //search results page toggle options
/*  THIS IS ALL IRRELEVANT 
    $('#sort').change(function() {
	var val = $(this).val();
	console.log(val);
	console.log("success");
	$.ajax({
	    type: "GET",// GET in place of POST
	    contentType: "application/json; charset=utf-8",
	    url: "http://162.213.199.215:3000/search",
	    data: {search_string: window.location.hash["search_string"], sort_by: val},
	    dataType: "html",
	    success: function (result) {
		//do somthing here
		console.log("yay");
		console.log("RES: " + result);
		$('body').html(result);
	    },
	    error: function(e){
	    }
	});
	    
    });

*/

    //sell home
    window.setInterval(function(){
	$('.sell_active').fadeOut(550,function() {
	    $('.sell_active').toggleClass('sell_now').toggleClass('sell_now_other').fadeIn(550);
	});
    },4000);

    $('.gallery_other').mouseover(function() {
	var mainImg = $('#gallery_main_first').css('background-image');
	var otherImg = $(this).css('background-image');
	$(this).fadeOut(550, function() {
	    $(this).css('background-image', mainImg).fadeIn(550);
	});
	$('.gallery_main').fadeOut(550, function() {
	    $('.gallery_main').css('background-image', otherImg).fadeIn(550); 
	});

    });
    
    //header stuff
    $('.search_string').focusin(function() {

	if ($('.search_string').val().length == 0)
	{
	}
	else
	{
	    $('#sug_list').css('display', 'block');
	    updateSearch($('.search_string').val());
	}

    });

    var strToSave = "";

    $('.search_string').focusout(function() {
	hideSuggestions();
    });

    $('.search_string').keydown(function(event) {
	var key = event.which;
	if (key == 38 || key == 40) event.preventDefault();

    });

    $('.search_string').keyup(function(event) {
	
	var key = event.which;
	if (key == 38 || key == 40)
	{
	    event.preventDefault();
	    if (key == 40)
	    {
		var done = false;
		if (!($('#sug_list').hasClass('active')))
		{
		    $('#sug_list > :first-child').addClass('active');
		    $('#sug_list').addClass("active");
		    strToSave = $('.search_string').val();
		    console.log(strToSave);
		    done = true;
		}
		if ($('#sug_list > .active').is('#sug_list > :last-child') && !done)
		{
		    $('#sug_list > :last-child').removeClass('active');
		    $('#sug_list').removeClass('active');
		    done = true;
		    $('.search_string').val(strToSave);
		    strToSave = "";
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
		if (!($('#sug_list').hasClass('active')))
		{
		    $('#sug_list > :last-child').addClass('active');
		    done = true;
		    strToSave = $('.search_string').val();
		    $('#sug_list').addClass('active');
		}
		if ($('#sug_list > .active').is('#sug_list > :first-child') && !done)
		{
		    $('#sug_list > :first-child').removeClass('active');
		    $('#sug_list').removeClass('active');
		    done = true;
		    console.log(strToSave);
		    $('.search_string').val(strToSave);
		    strToSave = "";
		}
		if (!done)
		{
		    $('#sug_list > .active').prev().addClass('next');
		    $('#sug_list > .active').removeClass('active');
		    $('#sug_list > .next').addClass('active').removeClass('next');
		}
	    }
	    if ($('#sug_list').hasClass('active'))
	    {
		$('.search_string').val($('#sug_list > .active').text());

	    }
	}
	else
	{
	    updateSearch($('.search_string').val());
	}
	
    });

    $('#sug_list > li').mouseover(function() {
    });

    function hideSuggestions()
    {
	$('#sug_list').removeClass('active');
	$('#sug_list').html("");
	$('#sug_list').css('display', 'none');
    }

    function updateSearch(thing)
    {
	
	$.ajax({
	    type: "GET",// GET in place of POST
	    contentType: "application/json; charset=utf-8",
	    url: "http://162.213.199.215:3000/search_suggestions",
	    data: {search_string: thing},
	    dataType: "json",
	    success: function (result) {
		//do somthing here
		var str = "";
		res = "" + result;
		var parts = res.split(',');
		for (i in parts)
		{
		    var add = "<li>"
		    str += add + parts[i] + '</li>';
		}
		console.log(thing);
		console.log(res);
		$('#sug_list').html("");
		$('#sug_list').html(str);
		console.log(str);
		$('#sug_list').removeClass('active');
		if (res.length == 0 || thing.length == 0)
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
	//update search
	/*
	if (!($('#sug_list > .active').is('#sug_list > :first-child')))
	{
	    $('.search_string').val(('#sug_list > .active').text());
	    
	}
	*/

    }

    //home header
    $('.dropdown_header').mouseenter(function() {
	$('.dropdown_menu_header').css('display', 'block');
	console.log("Yup");
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
