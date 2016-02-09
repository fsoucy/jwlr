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
    url += "&price=";
    var first = false;
    $('input#price').each(function() {
	var val = $(this).val();
	if ($(this).is(':checked'))
	{
	    console.log(val);
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


    });
    window.location.href = url + hash;
}

/*function GetParameter(paramName, objectName)
{
  document.getElementById(objectName).value = window.location.href.location.split("&")[paramName];

  console.log(window.location.href.location.split("&")[paramName]);
}*/
