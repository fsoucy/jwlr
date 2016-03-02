/* this function iterates through each option in the sort_by
select dropdown, and appends the selected to the URL */
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

/*
This function is called to update the URL when actions are taken with the toggle options
or sorting or ordering preferences updated */
function leadToRefresh()
{
    var url = window.location.href;
    
    //here I'm going to clear the unnecessary hash in URL
    $('input.toggle').each(function(index, data) {
	var str = "&" + $(this).attr('name');
	if(url.indexOf(str) != -1)
	{
	    url = url.substring(0, url.indexOf(str));
	}
    });

    //clear the current sort by hash in URL
    if(url.indexOf("&sort_by") != -1)
    {
	url = url.substring(0, url.indexOf("&sort_by"));
    }

    //update sort by hash in the URL
    url = sortBy(url);

    //iterates through all checkboxes. if selected, add it to hash
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

    //if an attribute option is expanded, let hash know so it can stay expanded upon reload
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

    //update URL
    window.location.href = url;
}

function uponRefresh()
{
    var hash = window.location.href;
    //if the hash is empty, return an empty hash. if not, only get relevant part of hash (after first &)
    if (hash.indexOf('&') == -1 || hash.indexOf("=") == -1)
    {
	hash = "";
	return;
    }
    else
    {
	hash = hash.slice(hash.indexOf("&"), hash.length);
    }


    //delimits 
    var hashSplit = hash.split("&");
    hashSplit = hashSplit.slice(1,hashSplit.length); // don't want first value
    var dict = {}; // var dict = [];
    //console.log(hashSplit.toString());
    for (j in hashSplit)
    {
	var s = hashSplit[j];
	var thingString = s.slice(s.indexOf("=") + 1, s.length);
	thingString = thingString.split(",");
	dict[s.slice(s.indexOf("&") + 1, s.indexOf("="))] = thingString;
	/*dict.push({
	    key: s.slice(s.indexOf("&") + 1, s.indexOf("=")),
	    value: thingString
	});*/
    }
    //we now have a hash. keys are the names of the params. values are an array of appropriate values for the param
    $('input').each(function(index, data) {
	var name = $(this).attr('name');
	var val = $(this).val();
	if (dict[name] != null && dict[name].indexOf(val) != -1)    
	{
	    $(this).prop('checked', true);
	}
    });

    if(dict["sort_by"] != null)
    {
	$('select').val(dict["sort_by"][0]);
    }
    
    var loc = window.location.href;
    loc = loc.split("&");
    for (thing in loc)
    {
	x = loc[thing].indexOf('attr=');
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
	    var top = 10 + 216 * previousElements;
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
