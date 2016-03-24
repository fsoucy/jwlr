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
    $('.massage_container').scrollTop(10000000);
    var page = 1;
    $('.massage_container').scroll(function(event) {
	if ($('.massage_container').scrollTop() < 10)
	{
	    page = page + 1;
	    while (index < 30)
	    {
		str = 'Hello ' + hellos;
		hellos = hellos + 1;
		$('.massages').append('<li>' + str + '</li>');
		index = index + 1;
	    }
	}
    });

});
