$(document).on('click', '#back', function() {
  window.history.back();
});

/* this function iterates through each option in the sort_by
select dropdown, and appends the selected to the URL */
function sortBy(url) {
	afterURL = url
		$('option').each(function (index, data) {
			if ($(this).is(":selected")) {
				var optionString = "&sort_by=" + $(this).attr("value");

				afterURL += optionString;

			}
		});
	return afterURL;
}

function cleanURL(url)
{
    var afterURL = url;
    var hashIndex = afterURL.indexOf("&");
    if (hashIndex == -1)
    {
	return afterURL;
    }
    return afterURL.substring(0, hashIndex);
}

function stringToArray(str)
{
    var arr = [];
    for (var i = 0; i < str.length; i++)
    {
	arr.push(str.substring(i, i+1));
    }
    return arr;
}

// if in key and get =, inKey false and inVal true DONE
// if not in key and get &, in key is true DONE
//if in key and not =, add to key DONE
// if in val and not &, add to val DONE
// if adding to something and get plus, add space instead DONE
// if end and key length not 0, add to dict DONE
// if in val and get comma, add key and val to dict, val is "", key stays same, inVal still true DONE
// if not in key and get an &, append to key, inKey is true, if key length not 0 add to dict DONE    
function parseURL(url)
{
    var splitURL = stringToArray(url);
    var dict = {};
    var inKey = false;
    var inVal = false;
    var key = "";
    var val = [];
    var currentVal = "";
    for (var i = 0; i < splitURL.length; i++)
    {
	var current = splitURL[i];


	if (i == (splitURL.length - 1))
	{	    
	    if (key.length != 0)
	    {
		currentVal += current;
		val.push(currentVal);
		if (key in dict)
		{
		    for(var j = 0; j < val.length; j++)
		    {
			dict[key].push(val[j]);
		    }
		}
		else
		{
		    dict[key] = val;
		}
	    }
	}
	else
	{
	    
	    if (inKey)
	    {
		if (current == "=")
		{
		    inKey = false;
		    inVal = true;
		}
		else
		{
		    if (current == "%20")
		    {
			key += " ";
		    }
		    else
		    {
			key += current;
		    }
		}
	    }
	    else
	    {
		if (current == "&")
		{
		    val.push(currentVal);
		    if (key.length != 0)
		    {
			if (key in dict)
			{
			    for (var j = 0; j < val.length; j++)
			    {
				dict[key].push(val[j]);
			    }
			}
			else
			{
			    dict[key] = val;
			}
		    }
		    key = "";
		    val = [];
		    currentVal = "";
		    inKey = true;
		    inVal = false;
		}
		else
		{
		    if (inVal)
		    {
			if (current == ",")
			{
			    val.push(currentVal);
			    currentVal = "";
			}
			else if (current == "%20")
			{
			    currentVal += " ";
			}
			else
			{
			    currentVal += current;
			}
		    }
		}
	    }
	}
	    
    }
    return dict;
}

function generateHash(dict)
{
    var hash = "";
    for (key in dict)
    {
	var toAdd = "";
	toAdd += "&" + key + "=";
	for (var i = 0; i < dict[key].length; i++)
	{
	    if (i == 0)
	    {
		toAdd += dict[key][i];
	    }
	    else
	    {
		toAdd += "," + dict[key][i];
	    }
	}
	hash += toAdd;
    }
    return hash;
}


function dictToURL(dict)
{
    var hash = generateHash(dict);
    var base = window.location.protocol + "//" + window.location.host + "/search?utf8=%E2%9C%93";
    var str = base + hash;
    return str.replace(' ', '%20');
}

function stringToDict()
{
    var dict = {};
    dict["search_string"] = $('.search_string').val();
    return dict;
}

function sortByToDict()
{
    var dict = {};
    $('option').each(function (index, data) {
	if ($(this).is(":selected"))
	{
	    dict["sort_by"] = [$(this).attr("value")];
	}
    });
    return dict;
}

function checkboxToDict()
{
    var dict = {};
    $('input.toggle').each(function (index, data) {
	if ($(this).prop('checked'))
	{
	    var key = $(this).attr('name');
	    var val = $(this).val();
	    if (key in dict)
	    {
		dict[key].push(val);
	    }
	    else
	    {
		dict[key] = [val];
	    }
	}
    });
    return dict;
    
}

function listsToDict()
{
    var dict = {};
    $('.attr_long').each(function(index, data) {
	if ($(this).hasClass('attr_active'))
	{
	    var val = $(this).siblings('h3').text();
	    if ("attr" in dict)
	    {
		dict["attr"].push(val);
	    }
	    else
	    {
		dict["attr"] = [val];
	    }
	}
    });
    return dict;
}

function priceToDict()
{
    var dict = {};
    var priceLower = parseInt($('#price_lower').val());
    var priceUpper = parseInt($('#price_upper').val());
    if (priceLower > 0)
    {
	dict["price_lower"] = [priceLower.toString()];
    }
    if (priceUpper > 0)
    {
	dict["price_upper"] = [priceUpper.toString()];
    }
    return dict;
    
}

function elementsToDict()
{
    var commit = {};
    commit["commit"] = ["Search"];
    var dict = $.extend(stringToDict(), commit, sortByToDict(), checkboxToDict(), listsToDict(), priceToDict());
    return dict;	
}

function URLFromElements()
{
    var dict = elementsToDict();
    return dictToURL(dict);
}




    

/*
This function is called to update the URL when actions are taken with the toggle options
or sorting or ordering preferences updated */
function leadToRefresh() {
	var url = window.location.href;

	//here I'm going to clear the unnecessary hash in URL
	$('input.toggle').each(function (index, data) {
		var str = "&" + $(this).attr('name');
		if (url.indexOf(str) != -1) {
			url = url.substring(0, url.indexOf(str));
		}
	});
	//clear the current sort by hash in URL
	if (url.indexOf("&sort_by") != -1) {
		url = url.substring(0, url.indexOf("&sort_by"));
	}

	//update sort by hash in the URL
	url = sortBy(url);

	//iterates through all checkboxes. if selected, add it to hash
	$('input.toggle').each(function (index, data) {
		if ($(this).prop('checked')) {
			if (url.indexOf($(this).attr('name')) == -1) {
				str = $(this).attr('name');
				str = str.replace(' ', 'space');
				url += "&" + $(this).attr('name') + '=' + $(this).val();
			} else {
				url += "," + $(this).val();
			}
		}
	});

	//if an attribute option is expanded, let hash know so it can stay expanded upon reload
	$('.attr_long').each(function (index, data) {
		if ($(this).hasClass('attr_active')) {

			var attrString = "&" + "attr=" + $(this).siblings('h3').text();
			if (url.indexOf(attrString) == -1) {
				attrString = attrString.replace(" ", "_");
				url += attrString;

			}
		}
	});

	if (parseInt($('#price_lower').val()) != 0) {
		url += "&price_lower=" + $('#price_lower').val();
	}

	if (parseInt($('#price_upper').val()) != 0) {
		url += "&price_upper=" + $('#price_upper').val();
	}

	//update URL
	finalURL = url;
	if (url.indexOf("category_id") == -1) {
		var finalURL = "";
		var anotherHash = url.split("&");
		for (i in anotherHash) {
			var index = parseInt(i);

			if (anotherHash[index].indexOf("attribute_option_id") == -1) {
				if (index == 0) {
					finalURL += anotherHash[index];
				} else {
					finalURL += "&" + anotherHash[index];
				}
			} else {
				// no more attribute option ids
			}
		}
	}
	window.location.href = finalURL;
}

function uponRefresh() {

	var loc = window.location.href;
	loc = loc.split("&");
	for (thing in loc) {
		x = loc[thing].indexOf('attr=');
		if (x != -1) {
			var attribute = '.' + loc[thing].substring(x + 5);
			console.log(attribute);
			//$(attribute).siblings('.attr_short').css('display', 'none').removeClass('attr_active');
			$(attribute).siblings('.attr_long').css('display', 'block').addClass('attr_active');
		}
	}

	var hash = window.location.href;
	//if the hash is empty, return an empty hash. if not, only get relevant part of hash (after first &)
	if (hash.indexOf('&') == -1 || hash.indexOf("=") == -1) {
		hash = "";
		return;
	} else {
		hash = hash.slice(hash.indexOf("&"), hash.length);
	}

	//delimits
	var hashSplit = hash.split("&");
	hashSplit = hashSplit.slice(1, hashSplit.length); // don't want first value
	var dict = {}; // var dict = [];
	//console.log(hashSplit.toString());
	for (j in hashSplit) {
		var s = hashSplit[j];
		var thingString = s.slice(s.indexOf("=") + 1, s.length);
		thingString = thingString.split(",");
		var name = s.slice(s.indexOf("&") + 1, s.indexOf("="));
		name = name.replace('space', ' ');
		dict[name] = thingString;
		//dict.push({
		//    key: s.slice(s.indexOf("&") + 1, s.indexOf("=")),
		//    value: thingString
		//});
	}
	//we now have a hash. keys are the names of the params. values are an array of appropriate values for the param
	$('input').each(function (index, data) {
		var name = $(this).attr('name');
		var val = $(this).val();
		if (dict[name] != null && dict[name].indexOf(val) != -1) // && $(this).parent().hasClass('attr_active'))
		{
			//var todo = $(this).parent().attr('name') ==
			$(this).prop('checked', true);
		}
	});

	if (dict["sort_by"] != null) {
		$('select').val(dict["sort_by"][0]);
	}

  /*
	if ($('.result').length == 0) {
		var urlString = window.location.href;
		var hashSplit = urlString.split("&");
		var toGo = "";
		// "attribute_option_id", "category_id", "selling_method_id", "exchange_method_id", "payment_method_id", "price"
		for (uni in hashSplit) {
			unit = hashSplit[parseInt(uni)];
			if (unit.indexOf("attribute_option_id") != -1 || unit.indexOf("category_id") != -1 || unit.indexOf("selling_method_id") != -1 || unit.indexOf("exchange_method_id") != -1 || unit.indexOf("payment_method_id") != -1 || unit.indexOf("price") != -1) {
				//do nothing
			} else {
				if (parseInt(uni) == 0) {
					toGo += unit;
				} else {
					if (unit.indexOf("search_string") == -1) {
						toGo += "&" + unit;
					} else {
						toGo += "&" + "search_string=";
					}
				}
			}
		}
	    window.location.href = toGo;

	}*/

}

$(document).ready(function () {
	$('input.toggle').change(function () {
		leadToRefresh();
	});
	$('select.searchpage').change(function () {
		leadToRefresh();
	});

	$('#prices_man').click(function () {
		leadToRefresh();
	});
	if ($('#search_page').length > 0) {
		uponRefresh();
	}

    var arr = window.location.href.split("&");
    for (var i = 0; i < arr.length; i++)
    {
	var val = arr[i];
	if (val.indexOf("search_string") != -1)
	{
	    var search = val.substring(("search_string=").length);
	    $('.search_string').val(search.replace("+", " "));
	}
    }
    
	$('.result').click(function () {
		//$(this).append('<div class="buy_container"><p>Hello</p></div>');
		//$('.search_actions').fadeIn(500);
		if (!($(this).hasClass('active_search_result'))) {
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
		} else {
			$('.search_actions').fadeOut(500);
			$(this).removeClass('active_search_result');
		}

	});

	$('.options_dropdown_name').click(function () {
		//console.log("ok");
		if ($(this).siblings('.attr_long').hasClass('attr_active')) {
			$(this).siblings('.attr_long').css('display', 'none').removeClass('attr_active');
		} else {
			//$(this).siblings('.attr_short').css('display', 'none').removeClass('attr_active');
			$(this).siblings('.attr_long').css('display', 'block').addClass('attr_active');
		}

	});

	//really need to move this into smaller JS files
	$('.dropdown_menu_header > li').click(function () {
		var link = $(this).find('a').attr('href');
		window.location.href = link;
	});

	$('#sug_list').on('mouseenter', 'li', function () {
		$('#sug_list').addClass('active');
		$(this).addClass('active');
		strToSave = $('.search_string').val();
		$('.search_string').val($(this).text());
	});

	$('#sug_list').on('mouseleave', 'li', function () {
		$('#sug_list').removeClass('active');
		$(this).removeClass('active');
		$('.search_string').val(strToSave);
		searchToSave = "";
	});

	$('#sug_list').mousedown(function () {
		if ($(this).hasClass('active')) {
			var go = window.location.href;
			var goSplit = go.split("/");
			var url = goSplit[0];
			url = url + "/search?&search_string=" + $('.search_string').val();
			window.location.href = url;
		} else {
		}
	});

	//header stuff
	$('.search_string').focusin(function () {

		if ($('.search_string').val().length == 0) {}
		else {
			$('#sug_list').css('display', 'block');
			updateSearch($('.search_string').val());
		}

	});

	var strToSave = "";

	$('.search_string').focusout(function (e) {

		hideSuggestions();
	});

	$('.search_string').keydown(function (event) {
		var key = event.which;
		if (key == 38 || key == 40)
			event.preventDefault();

	});

	$('.search_string').keyup(function (event) {
		var key = event.which;
		if (key == 38 || key == 40) {
			event.preventDefault();
			if (key == 40) {
				var done = false;
				if (!($('#sug_list').hasClass('active'))) {
					$('#sug_list > :first-child').addClass('active');
					$('#sug_list').addClass("active");
					strToSave = $('.search_string').val();
					done = true;
				}
				if ($('#sug_list > .active').is('#sug_list > :last-child') && !done) {
					$('#sug_list > :last-child').removeClass('active');
					$('#sug_list').removeClass('active');
					done = true;
					$('.search_string').val(strToSave);
					strToSave = "";
				}
				if (!done) {
					$('#sug_list > .active').next().addClass('next');
					$('#sug_list > .active').removeClass('active');
					$('#sug_list > .next').addClass('active').removeClass('next');
				}
			}
			if (key == 38) {
				var done = false;
				if (!($('#sug_list').hasClass('active'))) {
					$('#sug_list > :last-child').addClass('active');
					done = true;
					strToSave = $('.search_string').val();
					$('#sug_list').addClass('active');
				}
				if ($('#sug_list > .active').is('#sug_list > :first-child') && !done) {
					$('#sug_list > :first-child').removeClass('active');
					$('#sug_list').removeClass('active');
					done = true;
					$('.search_string').val(strToSave);
					strToSave = "";
				}
				if (!done) {
					$('#sug_list > .active').prev().addClass('next');
					$('#sug_list > .active').removeClass('active');
					$('#sug_list > .next').addClass('active').removeClass('next');
				}
			}
			if ($('#sug_list').hasClass('active')) {
				$('.search_string').val($('#sug_list > .active').text());

			}
		} else {
			updateSearch($('.search_string').val());
		}

	});

	function hideSuggestions() {
		$('#sug_list').removeClass('active');
		$('#sug_list').html("");
		$('#sug_list').css('display', 'none');
	}

	function updateSearch(thing) {

		$.ajax({
			type : "GET", // GET in place of POST
			contentType : "application/json; charset=utf-8",
			url : window.location.protocol + "//" + window.location.host + "/search_suggestions",
			data : {
				search_string : thing
			},
			dataType : "json",
			success : function (result) {
				//do somthing here
				var str = "";
				res = "" + result;
				var parts = res.split(',');
				for (i in parts) {
					var add = "<li>"
						str += add + parts[i] + '</li>';
				}
				console.log(thing);
				console.log(res);
				$('#sug_list').html("");
				$('#sug_list').html("");
				$('#sug_list').html(str);
				console.log(str);
				$('#sug_list').removeClass('active');
				if (res.length == 0 || thing.length == 0) {
					$('#sug_list').css('display', 'none');
				} else {
					$('#sug_list').css('display', 'block');
				}
			},
			error : function (e) {}
		});

	}

});
