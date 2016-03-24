$(document).ready(function() {
    $('.cropped_show').click(function() {
	console.log('hi');
	smallImage = $(this).attr('src');
	smallLink = $(this).next().attr('href');
	largeImage = $('.product_image').attr('src');
	largeLink = $('.product_image').next().attr('href');
	$(this).attr('src', largeImage.replace('medium', 'thumbnail'));
	$('.product_image').attr('src', smallImage.replace('thumbnail', 'medium'));
	$('.product_image').next().attr('href', smallLink);
	$(this).next().attr('href', largeLink);
    });

});
