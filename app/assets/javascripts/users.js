$(document).on('click', 'button[id*=follow_]', function(event) {
  $.ajax({url: '/users/' + this.id.split("_")[1] + '/follow', type: 'POST', context: this, success: function() { 
    if($(this).html().trim() != "Me")
    {
      if($(this).html().trim() == "Follow")
      {
        $(this).html('Unfollow');
      }
      else
      {
        $(this).html('Follow');
      }
    }
  }});
});

$(document).on('click', 'button[id*=save_product_]', function (event) {
  $.ajax({url: '/users/' + this.id.split("_")[3] + '/save_product', type: 'POST', data: {product_id: this.id.split("_")[2]}, context: this, success: function() {
    if($(this).text() == "Remove")
    {
      $(this).parent().fadeOut(500, function() { 
        $(this).parent().remove(); 
      });
    }
    else if($(this).text() == "Add to wishlist")
    {
      $(this).text("Remove from wishlist");
    }
    else
    {
      $(this).text("Add to wishlist");
    }
  }});
});
