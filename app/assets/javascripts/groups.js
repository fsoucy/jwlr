$(document).on('input', '#user_name', function() {
  $.ajax({type: "GET", context: this, url: window.location.protocol + "//" + window.location.host + "/api/getUsers", data: {search_string: $(this).val()}, success: function(result) {
    $(this).siblings("#user_list").empty();
    var list = $(this).siblings("#user_list");
    result.forEach(function(user) {
      if(!$('.group_user_list').children('div:contains("' + user.name + '")').length)
      {
        if(user.following)
        {
          var following = "Unfollow";
        }
        else
        {
          var following = "Follow";
        }
        var output = '<div class="user"><img class="pure-img" src="' + user.profile_picture + '"><a href="/users/' + user.id + '"><h4>' + user.name + '</h4></a><button class="pure-button" id="groupadd_' + user.id + '">Add</button><button class="pure-button" id="follow_' + user.id + '">' + following + '</button></div>';
        list.append(output);
      }
    });
  }});
});

function refreshUserList(id)
{
  $.get(window.location.protocol + "//" + window.location.host + '/groups/' + id, function(data) {
    $(".group_user_list").replaceWith($(data).find(".group_user_list"));
  });
}

$(document).on('click', 'div[id*=group_]', function() {
  refreshUserList(this.id.split("_")[1]);
});

$(document).on('click', 'button[id*=groupadd_]', function() {
  $.ajax({type: "POST", url: window.location.protocol + "//" + window.location.host + '/groups/' + $("#group_id").val() + '/add_user', data: {user_id: this.id.split("_")[1]}, success: function() {
    refreshUserList($("#group_id").val());
  }});
});

