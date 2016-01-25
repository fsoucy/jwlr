$(document).ready(function() {

    //storefront
    $('.quick_view').hide();

    $('.quick_view').click(function() {
	var $toPut = "<div class='modal'><p>What the fuk</p></div>";
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
