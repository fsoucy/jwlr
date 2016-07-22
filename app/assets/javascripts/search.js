$(document).on('click', '#search_all', function() {
  var dict = parseURL(window.location.href);
  delete dict["user_id"];
  delete dict["store_id"];
  window.location.href = dictToURL(dict);  
});

$(document).on('click', '#back', function() {
    window.history.back();
});

function replaceAll(string, toReplace, replaceWith)
{
    var str = string;
    while (str.indexOf(toReplace) != -1)
    {
	str = str.replace(toReplace, replaceWith);
    }
    return str;
}

function parseURL(url)
{
    var array = url.split(/[?&]+/);
    var dict = {};
    for (var i = 0; i < array.length; i++)
    {
	var str = array[i];
	if (str.indexOf("=") != -1)
	{
	    var key = str.substring(0, str.indexOf("="));
	    var val = str.substring(str.indexOf("=") + 1);
	    dict[replaceAll(key, "+", " ")] = replaceAll(val, "+", " ").split(",");
	}
    }
    return dict;
}

function containsCategory(dict)
{
    if (dict["category_id"] == null)
    {
	delete dict["attr"];
	delete dict["attribute_option_id"];
    }
    return dict;
}

function generateHash(oldDict)
{
    var dict = containsCategory(oldDict);
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
    return replaceAll(str, " ", "+");
}

function stringToDict()
{
    var dict = {};
    dict["search_string"] = [$('.search_string').val()];
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
    debugger;
    var oldUrl = parseURL(window.location.href);
    if(typeof(oldUrl["user_id"]) != "undefined")
    {
      dict["user_id"] = oldUrl["user_id"];
    }
    if(typeof(oldUrl["store_id"]) != "undefined")
    {
      dict["store_id"] = oldUrl["store_id"];
    }
    return dict;
}

function URLFromElements()
{
    var dict = elementsToDict();
    return dictToURL(dict);
}

function executeSearch()
{
    window.location.href = URLFromElements();
}

function searchStringFromDict(dict)
{
    if ("search_string" in dict)
    {
	$('.search_string').val(dict["search_string"][0]);
    }
}

function togglesFromDict(dict)
{
    $("input.toggle").each(function(index, data) {
	var key = $(this).attr("name");
	var val = $(this).val();
	if (dict[key] != null && $.inArray(val, dict[key]) != -1)
	{
	    $(this).prop('checked', true);
	}
    });
}

function priceFromDict(dict)
{
    if (dict["price_lower"] != null && parseInt(dict["price_lower"]) > 0)
    {
	$('#price_lower').val(dict["price_lower"]);
    }
    if (dict["price_upper"] != null && parseInt(dict["price_upper"]) > 0)
    {
	$('#price_upper').val(dict["price_upper"]);
    }
}

function sortByFromDict(dict)
{
    if (dict["sort_by"] != null)
    {
	$('#sort').val(dict["sort_by"]);
    }
}

function listsFromDict(dict)
{
    if (dict["attr"] != null)
    {
	for (var i = 0; i < dict["attr"].length; i++)
	{
	    var thing = "." + dict["attr"][i];
	    thing = thing.replace(" ", "_");
	    $(thing).siblings('.attr_long').css('display', 'block').addClass("attr_active");
	}
    }
}

function uponRefresh()
{
    //unselect everything
    $('input.toggle').prop('checked', false);
    var dict = parseURL(window.location.href);
    searchStringFromDict(dict);
    togglesFromDict(dict);
    priceFromDict(dict);
    sortByFromDict(dict);
    listsFromDict(dict);
}


$(document).ready(function () {
    $('input.toggle').change(function () {
	executeSearch();
    });
    $('select.searchpage').change(function () {
	executeSearch();
    });

    $('#prices_man').click(function () {
	executeSearch();
    });
    if ($('#search_page').length > 0) {
	uponRefresh();
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
