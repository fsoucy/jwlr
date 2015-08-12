$(document).ready(function() {
	$('.gold_coins_div').hide();
	$('.jewelry_div').hide();
	$('.gold_bricks_div').hide();
	$('.precious_stones_div').hide();
	
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

	

    });