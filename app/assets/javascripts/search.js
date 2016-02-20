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
	    console.log(url);
	    url = url.substring(0, url.indexOf(str));
	    console.log(url);
	}
    });
    $('input.toggle').each(function(index, data) {
	if ($(this).prop('checked'))
	{
	    console.log($(this).val());
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
	    url += "&" + "attr=" + $(this).siblings('h3').text();
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
		//console.log(name);
		//console.log(val);
		//console.log(dict[key]["key"]);
		//console.log(dict[key]["value"]);
		$(this).prop('checked', true);
	    }
	}
    });
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
	$('.search_actions').fadeIn(500);
	$('.result').removeClass('active');
	$(this).addClass('active_search_result');
    });

    $('.category_name').click(function() {
	console.log("ok");
	$(this).siblings('.attr_short').css('display', 'none').removeClass('attr_active');
	$(this).siblings('.attr_long').css('display', 'block').addClass('attr_active');
	
    });
});
