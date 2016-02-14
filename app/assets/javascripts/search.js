

function setGetParameter(paramName, paramValue)
{
    $('input#price').each(function() {
	var val = $(this).val();
	if ($(this).is(':checked'))
	{
	    console.log(val);
	}
	else
	{
	    console.log('nope');
	}
	
	
    });
    
    var url = window.location.href;
    var hash = location.hash;
    url = url.replace(hash, '');
    if (url.indexOf(paramName + "=") >= 0)
    {
        var prefix = url.substring(0, url.indexOf(paramName));
        var suffix = url.substring(url.indexOf(paramName));
        suffix = suffix.substring(suffix.indexOf("=") + 1);
        suffix = (suffix.indexOf("&") >= 0) ? suffix.substring(suffix.indexOf("&")) : "";
        url = prefix + paramName + "=" + paramValue + suffix;
    }
    else
    {
    if (url.indexOf("?") < 0)
        url += "?" + paramName + "=" + paramValue;
    else
        url += "&" + paramName + "=" + paramValue;
    }

    var first = false;
    $('input').each(function() {
	var val = $(this).val();
	if ($(this).is(':checked') && url.indexOf(val) == -1)
	{
	    
	    console.log(val);
	    if (url.indexOf($(this).attr('name') == -1))
	    {
		url += "&" + $(this).attr('name') + "=";
	    }
	    
	    if (first)
	    {
		url += "," + val;
	    }
	    else
	    {
		url += val;
		first = true;
	    }
	}
	else
	{
	    console.log('nope');
	}
	first = false;


    });
    window.location.href = url + hash;
}

$(document).ready(function() {
    $('input.toggle').change(function() {
	setGetParameter("sort_by", $('#sort').val());
    });
    var hash = window.location.href;
    console.log(hash);
    var arr = [];
    $('input').each(function(index, data) {
	var val = $(this).val();
	if(!(hash.indexOf(val) == -1))
	{
	    $(this).prop('checked', true);
	}
    });
});
