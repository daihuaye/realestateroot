/*
Jquery and Rails powered default application.js
Easy Ajax replacement for remote_functions and ajax_form based on class name
All actions will reply to the .js format
Unostrusive, will only works if Javascript enabled, if not, respond to an HTML as a normal link
respond_to do |format|
format.html
format.js {render :layout => false}
end
*/
 
jQuery.ajaxSetup({ 'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")} })
 
function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}
 
jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});
 
/*
Submit a form with Ajax
Use the class ajaxForm in your form declaration
<% form_for @comment,:html => {:class => "ajaxForm"} do |f| -%>
*/
jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
		var searchText = $("#search_search_text").val();
		if(searchText !== "" && searchText !== "ZipCode, or City and State") {
			if($("span").hasClass("active")) {
				var div_id = $("span.active").parent("a").attr("class");
				$("#"+div_id).addClass("removed");
				$("span.active").removeClass("active");
			}
			var sites = ["trulia", "zillow", "realtor", "yahoo", "century21", "homes"];
			for(i = 0; i < 6; i++) {
				$("#"+sites[i]).html("");
			}
			set_loading_position();
			$(".loading").removeClass("removed");
	    $.post(this.action, $(this).serialize(), function(data) {
																																$("#start").addClass("removed");
																																$(".loading").addClass("removed");
																														 }, "script");
		} else {
			alertEmptyQuery();
		}
   return false;
  })
  return this;
};
 
/*
Retreive a page with get
Use the class get in your link declaration
*/
jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};
 
/*
Post data via html
Use the class post in your link declaration
*/
jQuery.fn.postWithAjax = function(data, text) {
  this.unbind('click', false);
  this.click(function() {
		set_loading_position();
		$(".loading").removeClass("removed");
    $.post($(this).attr("href"), data, function() { $("#search_search_text").val(text);
																										$("#start").addClass("removed");
																										$(".loading").addClass("removed");
																									}, "script");
    return false;
  })
  return this;
};

jQuery.fn.postWithAjaxForSearch = function(site) {
	this.unbind('click', false);
	this.click(function() {
		if(!$("#site_nav").hasClass("removed") && !$("#"+site).find("iframe").hasClass("iFrame")) {
			if(!$("#site_nav").hasClass("removed") && $("#search_search_text").val() != "") {
				set_loading_position();
				$(".loading").removeClass("removed");
				var search_text = $("#search_search_text").val();
				var bathroom = $("#search_bath_room").val();
				var bedroom = $("#search_bed_room").val();
				var maxprice = $("#search_max_price").val();
				var minprice = $("#search_min_price").val();
				var data = "search[bath_room]="+ bathroom +"+&search[bed_room]="+ bedroom +"+&search[max_price]="+ maxprice +"&search[min_price]="+ minprice +"&search[search_text]="+ search_text;
				var search_url = "search/get_url_text/"+site;
				$.post(search_url, data, function() { 
																							var disable = $("span.active").next("span");
																							disable.addClass("hover");
																							disable.animate({
																								'opacity': 0
																								}, 700, 'easeOutQuad');
																							var div_id = $("span.active").parent("a").attr("class");
																							$("#"+div_id).addClass("removed");
																							$("span.active").removeClass("active");
																							$("a."+site+">.hover").removeClass("hover");
																							$("a."+site).prepend("<span class='active'></span>");
																							$(".loading").addClass("removed");
																							}, "script");
				return false;
			}
		} else if($("#"+site).find("iframe").hasClass("iFrame")) {
			var disable = $("span.active").next("span");
			disable.addClass("hover");
			disable.animate({
				'opacity': 0
				}, 700, 'easeOutQuad');
			var div_id = $("span.active").parent("a").attr("class");
			$("#"+div_id).addClass("removed");
			$("span.active").removeClass("active");
			$("a."+site+">.hover").removeClass("hover");
			$("a."+site).prepend("<span class='active'></span>");
			$("#"+site).removeClass("removed");
			return false;
		} else {
			errorAlert();
		}
	})
	
	return this;
};

/*
Update/Put data via html
Use the class put in your link declaration
*/
jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.click(function() {
    $.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};
 
/*
Delete data
Use the class delete in your link declaration
*/
jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.click(function() {
    $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};
 
/*
Ajaxify all the links on the page.
This function is called when the page is loaded. You'll probaly need to call it again when you write render new datas that need to be ajaxyfied.'
*/
function ajaxLinks(){
    $('.ajaxForm').submitWithAjax();
    $('a.get').getWithAjax();
    $('a.post').postWithAjax();
		$('a.put').putWithAjax();
    $('a.delete').deleteWithAjax();
}
 
$(document).ready(function() {
// All non-GET requests will add the authenticity token
 $(document).ajaxSend(function(event, request, settings) {
       if (typeof(window.AUTH_TOKEN) == "undefined") return;
       // IE6 fix for http://dev.jquery.com/ticket/3155
       if (settings.type == 'GET' || settings.type == 'get') return;
 
       settings.data = settings.data || "";
       settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
     });
 
  ajaxLinks();
});

//manage the real estate sites' tabs
// TODO use AJAX to add correct iframe to the correspoding tab

function callAjax() {
	$(".trulia").postWithAjaxForSearch("trulia");
	$(".zillow").postWithAjaxForSearch("zillow");
	$(".homes").postWithAjaxForSearch("homes");
	$(".yahoo").postWithAjaxForSearch("yahoo");
	$(".realtor").postWithAjaxForSearch("realtor");
	$(".century21").postWithAjaxForSearch("century21");
}

function set_loading_position() {
	var mid_width = document.body.scrollWidth/2 - 100;
	$(".loading").css({"top": "100px", "left": mid_width +"px"});
}

function navBarAnimate() {
	$('#navigation li a').append('<span class="hover"></span>');

	$('#navigation li a').hover(function() {
		$('.hover', this).stop().animate({
			'opacity': 1
			}, 700,'easeOutSine')

		},function() {
			$('.hover', this).stop().animate({
				'opacity': 0
				}, 700, 'easeOutQuad')

			});
}

function toggleSearchText() {
	$(":input").focusin(function(){
		$(this).removeClass("idleField");
		if(this.value == this.defaultValue){
			this.value = '';
		}
		if(this.value != this.defaultValue){
			this.select();
		}
	});
	$(":input").focusout(function(){
		if(this.value == '') {
			$(this).addClass("idleField");
			this.value = this.defaultValue;
		}
	});
}

//testing for iframe
function iframeSizeControll() {
	$(window).resize( function() {resizeIframe();} );
	resizeIframe();
}

function resizeIframe()
{
	calculateHeight("trulia");
	calculateHeight("zillow");
	calculateHeight("realtor");
	calculateHeight("yahoo");
	calculateHeight("century21");
	calculateHeight("homes");
}

function calculateHeight(id) {
	var height = WindowHeight() - getObjHeight(document.getElementById("toolbar"));
	$("#"+id).height( height );
}

function WindowHeight()
{
	var de = document.documentElement;
	return self.innerHeight ||
		(de && de.clientHeight ) ||
		document.body.clientHeight;
}

function getObjHeight(obj)
{
	if( obj.offsetWidth )
	{
		return obj.offsetHeight;
	}
	return obj.clientHeight;
}

function navigation() {
	$("#back").bind("click",function(){window.history.go(-1);});
	$("#forward").bind("click",function(){window.history.go(1);});
}

function searchKeyPress() {
	$("#search_text").bind("keypress", function(e) {
		e = e || window.event;
		if(e.keyCode == 13) {
			$('.ajaxForm').submit();
		}
	});
}

function errorAlert() {
	alert("Please start your search for your house first, then click the site navigation bar.");
}

function alertEmptyQuery() {
	alert("Oops! please enter zipcode, or city and state!");
}