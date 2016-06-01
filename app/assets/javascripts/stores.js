$(document).ready(function () {

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

});
