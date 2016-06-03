//Like a post
$(document).on('click', 'a[id*=like_]', function(event) {
  event.preventDefault();
  $.ajax({url: '/users/' + this.id.split("_")[3] + '/like', type: 'POST', context: this, data: {post_id: this.id.split("_")[2], post_type: this.id.split("_")[1]}, success: function() {
    if($(this).text().trim() == "Like")
    {
      $(this).text("Unike");
    }
    else
    {
      $(this).text("Like");
    }
    $.ajax({url: "/api/getLikes", type: 'GET', data: {post_id: this.id.split("_")[2], post_type: this.id.split("_")[1]}, context: this, success: function(data) {
      $(this).siblings("a[id*=likes_]").text(data.length + " " + ((data.length == 1) ? "Like" : "Likes"));
    }});
  }});  
});

//Hover like list
$(document).on('mouseenter', 'a[id*=likes_]', function(event) {
  $.ajax({url: "/api/getLikes", type: 'GET', data: {post_id: this.id.split("_")[2], post_type: this.id.split("_")[1]}, context: this, success: function(data) {
    $(this).parent().siblings("ul[id*=likesList_]").empty();
    if(data.length > 0)
    {
      for(i in data)
      {
        $(this).parent().siblings("ul[id*=likesList_]").append("<li>" + data[i].name  + "</li>");
      }
      $(this).parent().siblings("ul[id*=likesList_]").css({left: event.pageX, top: event.pageY});
      $(this).parent().siblings("ul[id*=likesList_]").show();
    }
  }});
});

$(document).on('mouseleave', 'a[id*=likes_]', function() {
  $(this).parent().siblings("ul[id*=likesList_]").hide();
});

//Click like list
$(document).on('click', 'a[id*=likes_]', function(event) { 
  event.preventDefault();
  $(this).parent().siblings("div[id*=commentsBox_]").children("#likesListLarge").show();
  $(this).parent().siblings("div[id*=commentsBox_]").children("#commentsList").hide();  
});

//Click comment list
$(document).on('click', 'a[id*=comments_]', function(event) { 
  event.preventDefault();
  $(this).parent().siblings("div[id*=commentsBox_]").children("#likesListLarge").hide();
  $(this).parent().siblings("div[id*=commentsBox_]").children("#commentsList").show();  
});

$(document).ready(function () {
  $("#commentsList").scrollTop(10000000);
});

//Submit comment
$(document).on('click', 'button[id*=commentForm_]', function(event) {
  event.preventDefault();
  var form_data = {};
  form_data["comment_string"] = $(this).siblings("input[type=text]").val();
  form_data["post_id"] = this.id.split("_")[2];
  form_data["post_type"] = this.id.split("_")[1];
  form_data["user_id"] = this.id.split("_")[3];
  
  $.ajax({ 
    type: "POST",
    url: "/users/" + form_data["user_id"] + "/comment",
    data: form_data,
    success: function (data) {
      location.reload();
    }   
  });
});

$(document).on('focus', '#comment', function(event) {
  $(this).keydown(function(event){ 
    var keyCode = (event.keyCode ? event.keyCode : event.which);   
    if(keyCode == 13) 
    {
      $(this).siblings('button[id*=commentForm_]').trigger('click');
    }
  });
});

//Edit Microposts
$(document).on('click', 'a[id*=delete_micropost_]', function(event) {
  event.preventDefault();
  $.ajax({url: '/microposts/' + this.id.split("_")[2], type: 'DELETE', context: this, success: function() {    
    $(this).parent().parent().fadeOut(500, function() { $(this).remove(); });
  }});
});

//Delete Microposts
$(document).on('click', 'a[id*=edit_micropost_]', function(event) {
  event.preventDefault();
  var old_text = $(this).siblings('#main_text').text().trim();
  var micropost_id = this.id.split("_")[2];
  $(this).siblings('#main_text').replaceWith($('#new_micropost').clone());
  $(this).siblings('form').children('fieldset').children('input[type=submit]').val("Save");
  $(this).siblings('form').children('fieldset').children('input[type=text]').val(old_text);
  $(this).siblings('form').bind("submit", function (event) {
    event.preventDefault();
    var new_text = $(this).children('fieldset').children('input[type=text]').val();
    $.ajax({url: '/microposts/' + micropost_id, type: 'PATCH', context: this, data: $(this).serialize(), success: function() {
      $(this).fadeOut(500, function() { $(this).replaceWith('<p id="main_text">' + new_text + '</p>'); });
    }});
  });
});

$(window).scroll(function() {
  if($('.feed_item').length)
  {
    if(($(window).scrollTop() + $(window).height() > $(document).height() - 200) && (window.feed_scrolling == false || typeof window.feed_page == 'undefined'))
    {
      window.feed_scrolling = true;
      if(typeof window.feed_page != 'undefined')
      {
        window.feed_page += 1;
      }
      else
      {
        window.feed_page = 2;
      }
      $.get('http://' + window.location.host + '/?page=' + window.feed_page, function(result) {
        $('#feed').append($(result).find('#feed').children());      
        window.feed_scrolling = false;
      });
    }
  }
});
