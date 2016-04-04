$(document).ready(function() {
    $('#coins').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=17';
    });
    $('#bullion').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=14';
    });
    $('#watch').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=10';
    });
    $('#necklace').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=3';
    });
    $('#ring').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=2';
    });
    $('#jewelry').click(function() {
	window.location.href += 'search?' + 'search_string=&category_id=1';
    });


/*
    window.setInterval(function(){
	$('.sell_active').fadeOut(550,function() {
	    $('.sell_active').toggleClass('sell_now').toggleClass('sell_now_other').fadeIn(550);
	});
    },4000);
*/
    $('.gallery_other').mouseenter(function() {
	var mainImg = $('#gallery_main_first img');
	var otherImg = $('img', this);
	var mainLink = $('#gallery_main_first a').attr('href');
	var otherLink = $('a', this).attr('href');
	otherImg = jQuery.extend(true, {}, otherImg);
	//$('img', this).fadeOut(550, function() {
	//    $('img', this).attr('src', mainImg.attr('src')).fadeIn(550);
	//});
	var src = otherImg.attr('src');
	var alt = otherImg.attr('alt');
	if (src == null)
	{
	    src = "";
	    alt = "";
	}
	if (mainImg.attr('src') != null)
	{
	    $('img', this).attr('src', mainImg.attr('src').replace('thumb', 'thumb'));
	}
	$('#gallery_main_first img').attr('src', src.replace('thumb', 'thumb'));
	$('#gallery_main_first img').attr('alt', alt);
	$('#gallery_main_first a').attr('href', otherLink);
	$('a', this).attr('href', mainLink);
    });

    $('.featured_other').mouseenter(function() {
	var mainImg = $('#featured_main_first img');
	var otherImg = $('img', this);
	var mainLink = $('#featured_main_first a').attr('href');
	var otherLink = $('a', this).attr('href');
	otherImg = jQuery.extend(true, {}, otherImg);
	//$('img', this).fadeOut(550, function() {
	//    $('img', this).attr('src', mainImg.attr('src')).fadeIn(550);
	//});
	var src = otherImg.attr('src');
	var alt = otherImg.attr('alt');
	if (src == null)
	{
	    src = "";
	    alt = "";
	}
	if (mainImg.attr('src') != null)
	{
	    $('img', this).attr('src', mainImg.attr('src').replace('thumb', 'thumb'));
	}
	$('#featured_main_first img').attr('src', src.replace('thumb', 'thumb'));
	$('#featured_main_first img').attr('alt', alt);
	$('#featured_main_first a').attr('href', otherLink);
	$('a', this).attr('href', mainLink);
    });
    

});
