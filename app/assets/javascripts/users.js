$(document).on('click', 'button[id*=follow_]', function(event) {
  $.ajax({url: '/users/' + this.id.split("_")[1] + '/follow', type: 'POST', context: this, success: function() { 
    if($(this).html().trim() == "Follow")
    {
      $(this).html('Unfollow');
    }
    else
    {
      $(this).html('Follow');
    }
  }});
});
