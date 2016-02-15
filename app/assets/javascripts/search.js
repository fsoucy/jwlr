
/*
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
    }*/

function leadToRefresh()
{
    var url = window.location.href;
    var hash = location.hash;
    url = url.replace(hash, '');
    console.log(url);
    //here I'm going to clear the unnecessary hash in URL
    $('input.toggle').each(function(index, data) {
	var str = "&" + $(this).attr('name');
	if(url.indexOf(str) != -1)
	{
	    url = url.substring(0, url.indexOf(str));
	}
    });
    $('input.toggle').each(function(index, data) {
	if ($(this).is(':checked'))
	{
	    if (url.indexOf($(this).attr('name')) == -1)
	    {
		url += "&" + $(this).attr('name') + '=' + $(this).val();
	    }
	    else
	    {
		url += "," + $(this).val();
	    }
	}
    });
    window.location.href = url;
}

function uponRefresh()
{
    var hash = window.location.href;
    if (hash.indexOf('&') == -1 || hash.indexOf("=") == -1)
    {
	hash = "";
	return;
    }
    else
    {
	hash = hash.slice(hash.indexOf("&"), hash.length);
    }
    //console.log(hash);

    var hashSplit = hash.split("&");
    hashSplit = hashSplit.slice(1,hashSplit.length);
    var dict = [];
    //console.log(hashSplit.toString());
    for (j in hashSplit)
    {
	var s = hashSplit[j];
	var thingString = s.slice(s.indexOf("=") + 1, s.length);
	thingString = thingString.split(",");
	/*
	var thing = [];
	for(var k = 0; k < thingString.length; k++)
	{
	    thing.push(parseInt(thingString[k]));
	}
	*/
	dict.push({
	    key: s.slice(s.indexOf("&") + 1, s.indexOf("=")),
	    value: thingString
	});
    }
    for (key in dict)
    {
	//console.log(dict[key]["key"]);
	//console.log(dict[key]["value"]);
    }
    
    $('input').each(function(index, data) {
	var name = $(this).attr('name');
	var val = $(this).val();
	//console.log(name);
	//console.log(val);
	for (key in dict)
	{
	    var nameMatch = dict[key]["key"] == name;
	    var valMatch = false;
	    for(var n = 0; n < dict[key]["value"].length; n++)
	    {
		if (dict[key]["value"][n] == val) valMatch = true;
	    }
	    //var valMatch = dict[key]["value"].contains(val);
	    if (valMatch && nameMatch)
	    {
		console.log(name);
		console.log(val);
		console.log(dict[key]["key"]);
		console.log(dict[key]["value"]);
		$(this).prop('checked', true);
	    }
	}
    });
}

$(document).ready(function() {
    $('input.toggle').change(function() {
	leadToRefresh();
    });
    /*
    var toStr = window.location.href;
    var hash = "" + toStr;
    if (hash.indexOf('&') != -1)
    {
	hash = hash.slice(hash.indexOf("&"), hash.length);
	console.log(hash);
    }
    else
    {
	hash = "";
    }
    var arr = [];
*/
    uponRefresh();
});
