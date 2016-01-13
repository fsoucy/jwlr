$(document).ready(function() {
	$("#red").on('input', colorChange);
	$("#green").on('input', colorChange);
	$("#blue").on('input', colorChange);

	function colorChange()
	{
	    var red = $('#red').val();
	    var green = $('#green').val();
	    var blue = $('#blue').val();
	    
	    var hexColor = rgbToHex(red, green, blue);
	    var str = "5px solid #" + hexColor;
	    console.log(hexColor);
	    $('.description').css('border', str);
	}

	function rgbToHex(r, g, b)
	{
	    var red = parseInt(r).toString(16);
	    var green = parseInt(g).toString(16);
	    var blue = parseInt(b).toString(16);
	    if (red.length === 1)
		{
		    red = "0" + red;
		}
	    if (green.length === 1)
		{
		    green = "0" + green;
		}
	    if (blue.length === 1)
		{
		    blue = "0" + blue;
		}
	    return red + blue + green;
	}

    });