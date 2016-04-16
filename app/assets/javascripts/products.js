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

});
