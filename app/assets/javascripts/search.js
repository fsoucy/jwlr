function sortBy(url)
{
    afterURL = url
    $('option').each(function(index, data) {
	if ($(this).is(":selected"))
	{
	    var optionString = "&sort_by=" + $(this).attr("value");

	    afterURL += optionString;
	    
	}
    });
    return afterURL;
}

function leadToRefresh()
{
    var url = window.location.href;
    var hash = location.hash;
    url = url.replace(hash, '');
    
    //here I'm going to clear the unnecessary hash in URL
    $('input.toggle').each(function(index, data) {
	var str = "&" + $(this).attr('name');
	//console.log(str);
	if(url.indexOf(str) != -1)
	{
	    url = url.substring(0, url.indexOf(str));
	}
    });

    if(url.indexOf("&sort_by") != -1)
    {
	url = url.substring(0, url.indexOf("&sort_by"));
    }

    url = sortBy(url);
    
    $('input.toggle').each(function(index, data) {
	if ($(this).prop('checked'))
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
    console.log(url);
    $('.attr_long').each(function(index, data) {
	if ($(this).hasClass('attr_active'))
	{
	    
	    var attrString = "&" + "attr=" + $(this).siblings('h3').text();
	    if (url.indexOf(attrString) == -1)
	    {
		url += attrString;
	    }
	}
    });
    console.log(url);
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
		//console.log(name);
		//console.log(val);
		//console.log(dict[key]["key"]);
		//console.log(dict[key]["value"]);
		$(this).prop('checked', true);
	    }
	}
    });

    for(key in dict)
    {
	if (dict[key]["key"] == "sort_by")
	{
	    $('select').val(dict[key]["value"][0]);
	}
    }
    var loc = window.location.href;
    loc = loc.split("&");
    var arr = [];
    for (thing in loc)
    {
	x = loc[thing].indexOf('attr=');
	//console.log(x + 5);
	//console.log(loc[thing]);
	//console.log(loc[thing].substring(x + 5));
	if (x != -1)
	{
	    var attribute = '.' + loc[thing].substring(x + 5);
	    $(attribute).siblings('.attr_short').css('display', 'none').removeClass('attr_active');
	    $(attribute).siblings('.attr_long').css('display', 'block').addClass('attr_active');
	}
    }
}


$(document).ready(function() {
    $('input.toggle').change(function() {
	leadToRefresh();
    });
    $('select').change(function() {
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
    $('.result').click(function() {
	//$(this).append('<div class="buy_container"><p>Hello</p></div>');
	//$('.search_actions').fadeIn(500);
	if (!($(this).hasClass('active_search_result')))
	{
	    $('.result').removeClass('active_search_result')
	    var previousElements = parseInt($(this).index('.result'));
	    var resHeight = parseInt($(this).css('height') + 2 * $(this).css('margin') + 2 * $(this).css('padding'));
	    //console.log(previousElements);
	    //console.log(resHeight);
	    $('.search_actions').css('height', $(this).css('height'));
	    $('.search_actions').css('margin-bottom', $(this).css('margin-bottom'));
	    var top = 10 + resHeight * previousElements;
				 //console.log(top);
	    
	    $('.search_actions').css('margin-top', top + "px");
	    $('.result').removeClass('active');
	    $(this).addClass('active_search_result');
	    $('.search_actions').fadeIn(500);
	}
	else
	{
	    $('.search_actions').fadeOut(500);
	    $(this).removeClass('active_search_result');
	}
	
    });

    $('.category_name').click(function() {
	console.log("ok");
	$(this).siblings('.attr_short').css('display', 'none').removeClass('attr_active');
	$(this).siblings('.attr_long').css('display', 'block').addClass('attr_active');
	
    });

});
